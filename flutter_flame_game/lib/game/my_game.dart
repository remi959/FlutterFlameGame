import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../components/player/player_component.dart';
import '../components/enemy/enemy_component.dart';
import '../components/player/player_controls_component.dart';
import '../behaviours/movement/default_move_behaviour.dart';
import '../behaviours/jump/default_jump_behaviour.dart';
import '../behaviours/attack/shoot_behaviour.dart';
import '../states/character_cubit.dart';

// Managers
import '../managers/ecs_manager.dart';
import '../managers/enemy_ai_manager.dart';
import '../managers/enemy_spawn_manager.dart';

class MyGame extends FlameGame with HasKeyboardHandlerComponents {
  late final PlayerComponent player;

  // Managers
  late final ECSManager ecsManager;
  late final EnemyAIManager enemyAIManager;
  late final EnemySpawnManager enemySpawnManager;

  @override
  Color backgroundColor() => const Color(0xFF2A2A2A);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // --- MANAGERS SETUP ---
    ecsManager = ECSManager();
    ecsManager.initialize(size);

    // Enemy managers
    enemyAIManager = EnemyAIManager();
    enemySpawnManager = EnemySpawnManager(
      game: this,
      spawnInterval: 2.0,
      maxEnemies: 8,
      spawnAreaMin: Vector2(0, 250),
      spawnAreaMax: Vector2(size.x, 350),
    );

    // --- PLAYER SETUP ---
    final playerCubit = CharacterCubit();

    player = PlayerComponent(
      bloc: playerCubit,
      moveBehaviour: DefaultMoveBehaviour(moveSpeed: 200),
      jumpBehaviour: DefaultJumpBehaviour(),
      attackBehaviour: ShootBehaviour(
        bulletPool: ecsManager.bulletPool,
        attackCooldown: 0.2,
        bulletSpeed: 500,
      ),
      position: Vector2(100, 300),
    );

    add(PlayerControlsComponent(cubit: playerCubit));
    add(player);

    // Optional: Spawn initial wave
    enemySpawnManager.spawnWave(3);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    ecsManager.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update ECS through manager
    ecsManager.update(dt);

    // Update spawn manager
    enemySpawnManager.update(dt);

    // Update enemy AI
    final enemies = children.whereType<EnemyComponent>();
    enemyAIManager.updateEnemies(enemies, player.position);
  }

  @override
  void onRemove() {
    ecsManager.dispose();
    super.onRemove();
  }
}