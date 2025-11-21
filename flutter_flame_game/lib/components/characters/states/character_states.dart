import 'package:flame/components.dart';

import 'character_state_machine.dart';

class IdleCharacterState extends CharacterState {

  IdleCharacterState(super.character);

  @override
  void enter() {
    character.bloc.stopMoving();
    // Stop horizontal movement, preserve vertical
    final currentVel = character.body.linearVelocity;
    character.body.linearVelocity = Vector2(0, currentVel.y);
  }

  @override
  CharacterState? checkTransitions() {
    final state = character.bloc.state;

    if (!character.isAlive) {
      return DeathCharacterState(character);
    }

    if (state.isAttacking) {
      return AttackCharacterState(character);
    }
    if (state.isJumping && state.isOnGround) {
      return JumpCharacterState(character);
    }
    if (state.isMoving) {
      return MoveCharacterState(character);
    }
    return null;
  }
}

class MoveCharacterState extends CharacterState {
  MoveCharacterState(super.character);

  @override
  void update(double dt) {
    final state = character.bloc.state;
    final currentVel = character.body.linearVelocity;
    final moveSpeed = character.config.moveSpeed; // Get from config

    if (state.isMovingLeft) {
      character.body.linearVelocity = Vector2(-moveSpeed, currentVel.y);
      character.facingDirection = -1;
    } else if (state.isMovingRight) {
      character.body.linearVelocity = Vector2(moveSpeed, currentVel.y);
      character.facingDirection = 1;
    } else {
      character.body.linearVelocity = Vector2(0, currentVel.y);
    }
  }

  @override
  CharacterState? checkTransitions() {
    final state = character.bloc.state;

    if (!character.isAlive) {
      return DeathCharacterState(character);
    }

    if (state.isAttacking) {
      return AttackCharacterState(character);
    }
    if (state.isJumping && state.isOnGround) {
      return JumpCharacterState(character);
    }
    if (!state.isMoving) {
      return IdleCharacterState(character);
    }
    return null;
  }
}

class JumpCharacterState extends CharacterState {
  final double moveSpeed;

  JumpCharacterState(super.character, {this.moveSpeed = 10});

  @override
  void enter() {
    final state = character.bloc.state;

    if (state.isJumping && state.isOnGround) {
      final jumpForce = character.config.jumpForce;
      character.body.applyLinearImpulse(Vector2(0, -jumpForce));
      character.bloc.endJump();
    }
  }

  @override
  void update(double dt) {
    // Allow air control
    final state = character.bloc.state;
    final currentVel = character.body.linearVelocity;

    if (state.isMovingLeft) {
      character.body.linearVelocity = Vector2(-moveSpeed, currentVel.y);
      character.facingDirection = -1;
    } else if (state.isMovingRight) {
      character.body.linearVelocity = Vector2(moveSpeed, currentVel.y);
      character.facingDirection = 1;
    }
  }

  @override
  CharacterState? checkTransitions() {
    final state = character.bloc.state;

    if (!character.isAlive) {
      return DeathCharacterState(character);
    }

    if (state.isAttacking) {
      return AttackCharacterState(character);
    }
    if (state.isOnGround) {
      if (state.isMoving) {
        return MoveCharacterState(character);
      }
      return IdleCharacterState(character);
    }
    return null;
  }
}

class AttackCharacterState extends CharacterState {
  final double moveSpeed;
  bool attackExecuted = false;

  AttackCharacterState(super.character, {this.moveSpeed = 10});

  @override
  void enter() {
    character.performAttack();
    attackExecuted = true;
    character.bloc.endAttack();
  }

  @override
  void update(double dt) {
    // Allow movement during attack
    final state = character.bloc.state;
    final currentVel = character.body.linearVelocity;

    if (state.isMovingLeft) {
      character.body.linearVelocity = Vector2(-moveSpeed, currentVel.y);
      character.facingDirection = -1;
    } else if (state.isMovingRight) {
      character.body.linearVelocity = Vector2(moveSpeed, currentVel.y);
      character.facingDirection = 1;
    }
  }

  @override
  CharacterState? checkTransitions() {
    final state = character.bloc.state;

    if (!character.isAlive) {
      return DeathCharacterState(character);
    }

    // Wait for attack animation to complete
    if (attackExecuted && !character.animator.isAttacking) {
      if (state.isJumping && state.isOnGround) {
        return JumpCharacterState(character, moveSpeed: moveSpeed);
      }
      if (state.isMoving) {
        return MoveCharacterState(character);
      }
      return IdleCharacterState(character);
    }
    return null;
  }
}

class DeathCharacterState extends CharacterState {
  DeathCharacterState(super.character);

  @override
  void enter() {
    character.onDeath();
  }

  @override
  CharacterState? checkTransitions() {
    return null;
  }
}
