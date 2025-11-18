import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../behaviours/character_behaviour.dart';
import '../character_base.dart';

class PlayerComponent extends CharacterBase {
  final MoveBehaviour moveBehaviour;
  final JumpBehaviour jumpBehaviour;
  final AttackBehaviour attackBehaviour;

  PlayerComponent({
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

    // Add visual representation - a simple colored rectangle
    add(
      RectangleComponent(
        size: size,
        paint: Paint()..color = Colors.blue,
        children: [
          // Add a white "face" to show direction
          RectangleComponent(
            position: Vector2(size.x * 0.6, size.y * 0.2),
            size: Vector2(size.x * 0.3, size.y * 0.3),
            paint: Paint()..color = Colors.white,
          ),
        ],
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Strategy Pattern — injected behaviours act on CharacterBase
    moveBehaviour.update(dt, this);
    jumpBehaviour.update(dt, this);
    attackBehaviour.update(dt, this);
  }

  @override
  void performAttack() {
    // Implement your player-specific attack here
    print("Player attacking!");
    // e.g., spawn projectile, play sound, play animation, etc.
  }
}