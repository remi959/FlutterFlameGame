import '../character_behaviour.dart';
import '../../components/character_base.dart';

class DefaultAttackBehaviour implements AttackBehaviour {
  final double attackCooldown;

  double _cooldownTimer = 0;

  DefaultAttackBehaviour({this.attackCooldown = 0.25});

  @override
  void update(double dt, CharacterBase character) {
    if (_cooldownTimer > 0) {
      _cooldownTimer -= dt;
      return;
    }

    final state = character.bloc.state;

    if (state.isAttacking) {
      character.performAttack();
      _cooldownTimer = attackCooldown;
      character.bloc.endAttack(); // Clear attack flag
    }
  }
}