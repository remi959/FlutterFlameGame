import '../character_behaviour.dart';
import '../../components/character_base.dart';
import '../../states/character_state.dart';

class DefaultJumpBehaviour implements JumpBehaviour {
  final double jumpForce;
  final double gravity;

  DefaultJumpBehaviour({
    this.jumpForce = -400,
    this.gravity = 900,
  });

  @override
  void update(double dt, CharacterBase character) {
    // Apply gravity
    character.velocity.y += gravity * dt;

    // Jump only if grounded
    if (character.bloc.state == CharacterState.jumping &&
        character.isOnGround) {
      character.velocity.y = jumpForce;
      character.bloc.idle();
    }

    // Apply vertical movement
    character.position.y += character.velocity.y * dt;

    // Ground collision
    if (character.position.y >= character.groundY) {
      character.position.y = character.groundY;
      character.velocity.y = 0;
      character.isOnGround = true;
    } else {
      character.isOnGround = false;
    }
  }
}