import '../character_behaviour.dart';
import '../../components/character_base.dart';
import '../../states/character_state.dart';

class DefaultMoveBehaviour implements MoveBehaviour {
  final double moveSpeed;

  DefaultMoveBehaviour({this.moveSpeed = 200});

  @override
  void update(double dt, CharacterBase character) {
    final state = character.bloc.state;

    if (state == CharacterState.movingLeft) {
      character.position.x -= moveSpeed * dt;
      character.facingDirection = -1;
    } else if (state == CharacterState.movingRight) {
      character.position.x += moveSpeed * dt;
      character.facingDirection = 1;
    }
  }
}
