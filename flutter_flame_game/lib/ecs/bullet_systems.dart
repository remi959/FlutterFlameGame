import 'package:oxygen/oxygen.dart' as ox;
import 'package:flutter/material.dart';
import 'bullet_components.dart';
import 'bullet_pool.dart';

class BulletMovementSystem extends ox.System {
  late final ox.Query _query;
  final BulletPool bulletPool;
  final double gameWidth;
  final double gameHeight;
  final double offScreenBuffer; // How far off-screen before recycling

  BulletMovementSystem(
    this.bulletPool, {
    required this.gameWidth,
    required this.gameHeight,
    this.offScreenBuffer = 200,
  });

  @override
  void init() {
    _query = createQuery([
      ox.Has<BulletTag>(),
      ox.Has<BulletPosition>(),
      ox.Has<BulletVelocity>(),
      ox.Has<BulletActive>(),
    ]);
  }

  @override
  void execute(double dt) {
    for (final entity in _query.entities) {
      final activeComp = entity.get<BulletActive>();
      if (activeComp == null || !activeComp.value) continue;

      final posComp = entity.get<BulletPosition>();
      final velComp = entity.get<BulletVelocity>();
      if (posComp == null || velComp == null) continue;

      final pos = posComp.value;
      final vel = velComp.value;

      pos.x += vel.x * dt;
      pos.y += vel.y * dt;

      // Recycle when off-screen with buffer
      if (pos.x < -offScreenBuffer || 
          pos.x > gameWidth + offScreenBuffer || 
          pos.y < -offScreenBuffer || 
          pos.y > gameHeight + offScreenBuffer) {
        bulletPool.release(entity);
      }
    }
  }
}

class BulletRenderSystem extends ox.System {
  late final ox.Query _query;

  @override
  void init() {
    _query = createQuery([
      ox.Has<BulletTag>(),
      ox.Has<BulletPosition>(),
      ox.Has<BulletActive>(),
    ]);
  }

  /// Call this from your game's render method, passing the canvas
  void renderBullets(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = Colors.orange.withValues(alpha: 0.5);

    for (final entity in _query.entities) {
      final activeComp = entity.get<BulletActive>();
      if (activeComp == null || !activeComp.value) continue;

      final posComp = entity.get<BulletPosition>();
      if (posComp == null) continue;

      final pos = posComp.value;

      // Draw glow
      canvas.drawCircle(Offset(pos.x, pos.y), 8.0, glowPaint);
      
      // Draw bullet
      canvas.drawCircle(Offset(pos.x, pos.y), 5.0, paint);
    }
  }

  @override
  void execute(double dt) {
    // This system doesn't update per frame, only renders when called
  }
}