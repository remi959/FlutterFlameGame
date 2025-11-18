import '../character_behaviour.dart';
import '../../components/character_base.dart';

class DefaultMoveBehaviour implements MoveBehaviour {
  final double moveSpeed;

  DefaultMoveBehaviour({this.moveSpeed = 200});

  @override
  void update(double dt, CharacterBase character) {
    final state = character.bloc.state;

    if (state.isMovingLeft) {
      character.position.x -= moveSpeed * dt;
      character.facingDirection = -1;
    } else if (state.isMovingRight) {
      character.position.x += moveSpeed * dt;
      character.facingDirection = 1;
    }
  }
}