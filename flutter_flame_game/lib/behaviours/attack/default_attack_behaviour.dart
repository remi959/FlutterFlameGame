import '../character_behaviour.dart';
import '../../components/character_base.dart';
import '../../states/character_state.dart';

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

    if (character.bloc.state == CharacterState.attacking) {
      character.performAttack();
      _cooldownTimer = attackCooldown;
      character.bloc.idle();
    }
  }
}