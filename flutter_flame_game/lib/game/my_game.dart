import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart' as ox;

import '../components/player/player_component.dart';
import '../components/player/player_controls_component.dart';
import '../components/enemy/enemy_component.dart';
import '../behaviours/movement/default_move_behaviour.dart';
import '../behaviours/jump/default_jump_behaviour.dart';
import '../behaviours/attack/shoot_behaviour.dart';
import '../states/character_cubit.dart';

// ECS
import '../ecs/bullet_pool.dart';
import '../ecs/bullet_systems.dart';

class MyGame extends FlameGame with HasKeyboardHandlerComponents {
  late final PlayerComponent player;

  // ECS world & bullet pool
  late final ox.World ecsWorld;
  late final BulletPool bulletPool;
  late final BulletRenderSystem bulletRenderSystem;

  @override
  Color backgroundColor() => const Color(0xFF2A2A2A);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // --- ECS SETUP ---
    ecsWorld = ox.World();
    bulletPool = BulletPool(ecsWorld);

    final movementSystem = BulletMovementSystem(bulletPool);
    ecsWorld.registerSystem(movementSystem);
    movementSystem.init();
    

    // Create render system but don't register it in ECS update loop
    bulletRenderSystem = BulletRenderSystem()..world = ecsWorld;
    bulletRenderSystem.init();

    

    // --- PLAYER SETUP ---
    final playerCubit = CharacterCubit();

    player = PlayerComponent(
      bloc: playerCubit,
      moveBehaviour: DefaultMoveBehaviour(moveSpeed: 200),
      jumpBehaviour: DefaultJumpBehaviour(),
      attackBehaviour: ShootBehaviour(
        bulletPool: bulletPool,
        attackCooldown: 0.2,
        bulletSpeed: 500,
      ),
      position: Vector2(100, 300),
    );

    add(PlayerControlsComponent(cubit: playerCubit));
    add(player);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    bulletRenderSystem.renderBullets(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update ECS bullets
    ecsWorld.execute(dt);

    // Simple enemy AI
    final enemies = children.whereType<EnemyComponent>();
    for (final enemy in enemies) {
      enemy.thinkAI(player.position);
    }
  }
}
