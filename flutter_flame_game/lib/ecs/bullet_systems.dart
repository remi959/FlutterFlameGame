import 'package:oxygen/oxygen.dart' as ox;
import 'package:flutter/material.dart';

import 'bullet_ecs_components.dart';
import '../game/my_game.dart';

class BulletSyncSystem extends ox.System {
  late final ox.Query _query;

  @override
  void init() {
    _query = createQuery([
      ox.Has<BulletPosition>(),
      ox.Has<BulletBodyRef>(),
      ox.Has<BulletActive>(),
    ]);
  }

  @override
  void execute(double dt) {
    for (final e in _query.entities) {
      final active = e.get<BulletActive>()!;
      if (!active.value) continue;

      final pos = e.get<BulletPosition>()!;
      final bodyRef = e.get<BulletBodyRef>()!;
      final bulletComp = bodyRef.body;

      if (bulletComp == null || !bulletComp.isLoaded) continue;

      pos.value.setFrom(bulletComp.body.position);
    }
  }
}

class BulletLifetimeSystem extends ox.System {
  late final ox.Query _query;

  @override
  void init() {
    _query = createQuery([
      ox.Has<BulletLifetime>(),
      ox.Has<BulletActive>(),
      ox.Has<BulletBodyRef>(),
    ]);
  }

  @override
  void execute(double dt) {
    for (final e in _query.entities) {
      final life = e.get<BulletLifetime>()!;
      final active = e.get<BulletActive>()!;
      final bodyRef = e.get<BulletBodyRef>()!;

      if (!active.value) continue;

      life.age += dt;
      if (life.age > life.maxLifeTime) {
        if (bodyRef.entity != null && bodyRef.pool != null) {
          bodyRef.pool!.release(e);
        }
      }
    }
  }
}

class BulletRenderSystem extends ox.System {
  late final ox.Query _query;
  final MyGame game;

  BulletRenderSystem(this.game);

  @override
  void init() {
    _query = createQuery([ox.Has<BulletPosition>(), ox.Has<BulletActive>()]);
  }

  @override
  void execute(double dt) {
    // No update logic; rendering is done manually from ecs manager's render method
  }

  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.yellow;
    const double radiusPixels = 4.0;

    for (final e in _query.entities) {
      final pos = e.get<BulletPosition>()!;
      final active = e.get<BulletActive>()!;
      if (!active.value) continue;

      final screenPos = game.worldToScreen(pos.value);
      canvas.drawCircle(Offset(screenPos.x, screenPos.y), radiusPixels, paint);
    }
  }
}
