import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart' as ox;

import '../ecs/bullet_pool.dart';
import '../ecs/bullet_systems.dart';

class ECSManager {
  late final ox.World world;
  late final BulletPool bulletPool;
  late final BulletMovementSystem _movementSystem;
  late final BulletRenderSystem _renderSystem;

  /// Initialize the ECS world and all systems
  void initialize(Vector2 gameSize) {
    world = ox.World();
    bulletPool = BulletPool(world);

    // Setup movement system
    _movementSystem = BulletMovementSystem(
      bulletPool,
      gameWidth: gameSize.x,
      gameHeight: gameSize.y,
      offScreenBuffer: 200,
    );
    world.registerSystem(_movementSystem);
    _movementSystem.init();

    // Setup render system (not registered in update loop)
    _renderSystem = BulletRenderSystem()..world = world;
    _renderSystem.init();
  }

  /// Update all ECS systems
  void update(double dt) {
    world.execute(dt);
  }

  /// Render all bullets
  void render(Canvas canvas) {
    _renderSystem.renderBullets(canvas);
  }

  /// Cleanup resources
  void dispose() {
    // Add cleanup logic if needed
  }
}