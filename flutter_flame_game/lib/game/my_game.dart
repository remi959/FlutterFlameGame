import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/events.dart'; // <-- add this
import '../components/player/player_component.dart';
import '../components/player/player_controls_component.dart';
import '../components/enemy/enemy_component.dart';
import '../behaviours/movement/move_behaviour.dart';
import '../behaviours/jump/jump_behaviour.dart';
import '../behaviours/attack/attack_behaviour.dart';
import '../states/character_cubit.dart';

class MyGame extends FlameGame with HasKeyboardHandlerComponents { // <-- add mixin
  late final PlayerComponent player;

  @override
  Color backgroundColor() => const Color(0xFF2A2A2A);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // --- PLAYER SETUP ---
    final playerCubit = CharacterCubit();

    player = PlayerComponent(
      bloc: playerCubit,
      moveBehaviour: DefaultMoveBehaviour(moveSpeed: 200),
      jumpBehaviour: DefaultJumpBehaviour(),
      attackBehaviour: DefaultAttackBehaviour(),
      position: Vector2(100, 300),
    );

    add(PlayerControlsComponent(cubit: playerCubit));
    add(player);
  }

  @override
  void update(double dt) {
    super.update(dt);

    final enemies = children.whereType<EnemyComponent>();
    for (final enemy in enemies) {
      enemy.thinkAI(player.position);
    }
  }
}