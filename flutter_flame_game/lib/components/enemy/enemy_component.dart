import 'package:flame/components.dart';
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

    if (dx.abs() < 120) {
      bloc.attack();
    } else if (dx < 0) {
      bloc.moveLeft();
    } else {
      bloc.moveRight();
    }
  }
}
