import 'dart:math';
import 'package:flame/components.dart';
import '../components/enemy/enemy_component.dart';
import '../behaviours/movement/default_move_behaviour.dart';
import '../behaviours/jump/default_jump_behaviour.dart';
import '../behaviours/attack/default_attack_behaviour.dart';
import '../states/character_cubit.dart';
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

  EnemySpawnManager({
    required this.game,
    this.spawnInterval = 3.0, // Spawn every 3 seconds
    this.maxEnemies = 5,
    Vector2? spawnAreaMin,
    Vector2? spawnAreaMax,
  })  : spawnAreaMin = spawnAreaMin ?? Vector2(0, 250),
        spawnAreaMax = spawnAreaMax ?? Vector2(800, 350);

  /// Update spawn timer and spawn enemies when ready
  void update(double dt) {
    _spawnTimer += dt;

    if (_spawnTimer >= spawnInterval) {
      _spawnTimer = 0;
      _trySpawnEnemy();
    }
  }

  void _trySpawnEnemy() {
    final currentEnemies = game.children.whereType<EnemyComponent>().length;
    
    if (currentEnemies >= maxEnemies) {
      return; // Don't spawn if at max capacity
    }

    final enemy = _createRandomEnemy();
    game.add(enemy);
  }

  EnemyComponent _createRandomEnemy() {
    final enemyCubit = CharacterCubit();
    
    // Random position within spawn area
    final spawnX = spawnAreaMin.x + 
                   _random.nextDouble() * (spawnAreaMax.x - spawnAreaMin.x);
    final spawnY = spawnAreaMin.y + 
                   _random.nextDouble() * (spawnAreaMax.y - spawnAreaMin.y);

    // Random stats variation
    final moveSpeed = 100.0 + _random.nextDouble() * 100; // 100-200
    final attackCooldown = 0.3 + _random.nextDouble() * 0.4; // 0.3-0.7

    return EnemyComponent(
      bloc: enemyCubit,
      moveBehaviour: DefaultMoveBehaviour(moveSpeed: moveSpeed),
      jumpBehaviour: DefaultJumpBehaviour(),
      attackBehaviour: DefaultAttackBehaviour(attackCooldown: attackCooldown),
      position: Vector2(spawnX, spawnY),
    );
  }

  /// Spawn a wave of enemies
  void spawnWave(int count) {
    for (int i = 0; i < count; i++) {
      final currentEnemies = game.children.whereType<EnemyComponent>().length;
      if (currentEnemies >= maxEnemies) break;
      
      final enemy = _createRandomEnemy();
      game.add(enemy);
    }
  }

  /// Spawn enemy at specific location
  void spawnAt(Vector2 position) {
    final enemyCubit = CharacterCubit();
    
    final enemy = EnemyComponent(
      bloc: enemyCubit,
      moveBehaviour: DefaultMoveBehaviour(moveSpeed: 150),
      jumpBehaviour: DefaultJumpBehaviour(),
      attackBehaviour: DefaultAttackBehaviour(attackCooldown: 0.5),
      position: position.clone(),
    );

    game.add(enemy);
  }

  /// Clear all enemies from the game
  void clearAllEnemies() {
    final enemies = game.children.whereType<EnemyComponent>().toList();
    for (final enemy in enemies) {
      enemy.removeFromParent();
    }
  }

  /// Reset spawn timer (useful when changing game states)
  void reset() {
    _spawnTimer = 0;
  }
}