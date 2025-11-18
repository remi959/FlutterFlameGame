import '../character_behaviour.dart';
import '../../components/character_base.dart';

class DefaultJumpBehaviour implements JumpBehaviour {
  final double jumpForce;
  final double gravity;

  DefaultJumpBehaviour({
    this.jumpForce = -400,
    this.gravity = 900,
  });

  @override
  void update(double dt, CharacterBase character) {
    final state = character.bloc.state;

    // Apply gravity
    character.velocity.y += gravity * dt;

    // Jump only if grounded and jump flag is set
    if (state.isJumping && state.isOnGround) {
      character.velocity.y = jumpForce;
      character.bloc.endJump(); // Clear jump flag
    }

    // Apply vertical movement
    character.position.y += character.velocity.y * dt;

    // Ground collision
    if (character.position.y >= character.groundY) {
      character.position.y = character.groundY;
      character.velocity.y = 0;
      character.bloc.setOnGround(true);
    } else {
      character.bloc.setOnGround(false);
    }
  }
}