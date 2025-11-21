import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter_flame_game/components/characters/character_config.dart';

import '../components/characters/enemy/enemy_component.dart';
import '../components/characters/states/character_cubit.dart';
import '../game/my_game.dart';

class EnemySpawnManager {
  final MyGame game;
  final Random _random = Random();

  // Spawn configuration
  final double spawnInterval;
  final int maxEnemies;
  final Vector2 spawnAreaMin;
  final Vector2 spawnAreaMax;

  double _spawnTimer = 0;

  // Enemy type pool for variety
  final List<EnemyConfig> enemyTypes = [
    EnemyConfig.standard,
    EnemyConfig.fast,
    EnemyConfig.tank,
  ];

  EnemySpawnManager({
    required this.game,
    this.spawnInterval = 3.0,
    this.maxEnemies = 5,
    Vector2? spawnAreaMin,
    Vector2? spawnAreaMax,
  }) : spawnAreaMin = spawnAreaMin ?? Vector2(5, -6),
       spawnAreaMax = spawnAreaMax ?? Vector2(5, -6);

  void update(double dt) {
    _spawnTimer += dt;

    if (_spawnTimer >= spawnInterval) {
      _spawnTimer = 0;
      _trySpawnEnemy();
    }
  }

  void _trySpawnEnemy() {
    final currentEnemies = game.world.children
        .whereType<EnemyComponent>()
        .length;

    if (currentEnemies >= maxEnemies) {
      return;
    }

    final enemy = _createRandomEnemy();
    game.world.add(enemy);
  }

  EnemyComponent _createRandomEnemy() {
    final enemyCubit = CharacterCubit();

    // Randomly select enemy type
    final enemyConfig = enemyTypes[_random.nextInt(enemyTypes.length)];

    // Random spawn position
    final spawnX =
        spawnAreaMin.x +
        _random.nextDouble() * (spawnAreaMax.x - spawnAreaMin.x);
    final spawnY =
        spawnAreaMin.y +
        _random.nextDouble() * (spawnAreaMax.y - spawnAreaMin.y);

    return EnemyComponent(
      bloc: enemyCubit,
      initialPosition: Vector2(spawnX, spawnY),
      config: enemyConfig,
    );
  }

  void spawnWave(int count) {
    for (int i = 0; i < count; i++) {
      final currentEnemies = game.world.children
          .whereType<EnemyComponent>()
          .length;
      if (currentEnemies >= maxEnemies) break;

      final enemy = _createRandomEnemy();
      game.world.add(enemy);
    }
  }

  void clearAllEnemies() {
    final enemies = game.world.children.whereType<EnemyComponent>().toList();
    for (final enemy in enemies) {
      enemy.removeFromParent();
    }
  }

  void reset() {
    _spawnTimer = 0;
  }
}
