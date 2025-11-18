import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../behaviours/character_behaviour.dart';
import '../character_base.dart';

class EnemyComponent extends CharacterBase {
  final MoveBehaviour moveBehaviour;
  final JumpBehaviour jumpBehaviour;
  final AttackBehaviour attackBehaviour;

  EnemyComponent({
    required super.bloc,
    required this.moveBehaviour,
    required this.jumpBehaviour,
    required this.attackBehaviour,
    super.position,
    Vector2? size,
  }) : super(
          size: size ?? Vector2(50, 80),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add visual representation - different color from player
    add(
      RectangleComponent(
        size: size,
        paint: Paint()..color = Colors.red,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Shared behaviour logic
    moveBehaviour.update(dt, this);
    jumpBehaviour.update(dt, this);
    attackBehaviour.update(dt, this);
  }

  @override
  void performAttack() {
    print("Enemy attacking!");
    // Enemy-specific attack logic (bite, melee, projectile, etc)
  }

  /// Example simple AI — can be expanded later
  void thinkAI(Vector2 playerPos) {
    final dx = playerPos.x - position.x;
    final dy = playerPos.y - position.y;

    // Stop all actions first
    bloc.stopMoving();

    // Attack if close
    if (dx.abs() < 120 && dy.abs() < 50) {
      bloc.startAttack();
    } 
    // Move towards player
    else if (dx < -10) {
      bloc.setMovingLeft(true);
    } else if (dx > 10) {
      bloc.setMovingRight(true);
    }

    // Jump if player is above
    if (dy < -50 && bloc.state.isOnGround) {
      bloc.startJump();
    }
  }
}