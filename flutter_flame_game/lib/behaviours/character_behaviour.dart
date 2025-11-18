import '../components/character_base.dart';

/// Base behaviour for all character actions.
/// Behaviours follow the Strategy pattern and are injected into the character.
///
/// Every behaviour is updated each frame and may modify the character
/// based on its current state or internal logic.
abstract class CharacterBehaviour {
  void update(double dt, CharacterBase character);
}

/// Movement behaviour (left/right walking, dashing, patrolling, etc.)
abstract class MoveBehaviour extends CharacterBehaviour {}

/// Jump behaviour (vertical motion, gravity, variable jump, coyote time, etc.)
abstract class JumpBehaviour extends CharacterBehaviour {}

/// Attack behaviour (melee, ranged, special attacks).
abstract class AttackBehaviour extends CharacterBehaviour {}
