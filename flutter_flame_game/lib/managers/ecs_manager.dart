import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart' as ox;

import '../ecs/bullet_pool.dart';
import '../ecs/bullet_systems.dart';
import '../components/characters/enemy/enemy_component.dart';
import '../game/my_game.dart';

class ECSManager {
  late final ox.World world;
  late final BulletPool bulletPool;
  late final BulletRenderSystem _renderSystem;
  late final BulletSyncSystem _syncSystem;
  late final BulletLifetimeSystem _lifetimeSystem;

  void initialize(
    MyGame game,
    Iterable<EnemyComponent> Function() getEnemies,
  ) {
    world = ox.World();

    bulletPool = BulletPool(world);

    _syncSystem = BulletSyncSystem();
    _lifetimeSystem = BulletLifetimeSystem();
    _renderSystem = BulletRenderSystem(game);

    world
      ..registerSystem(_syncSystem)
      ..registerSystem(_lifetimeSystem)
      ..registerSystem(_renderSystem);

    _syncSystem.init();
    _lifetimeSystem.init();
    _renderSystem.init();
  }

  void update(double dt) {
    world.execute(dt);
  }

  void render(Canvas canvas) {
    _renderSystem.render(canvas);
  }

  void dispose() {
    bulletPool.dispose();
  }
}