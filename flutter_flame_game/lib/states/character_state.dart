class CharacterState {
  bool isMovingLeft = false;
  bool isMovingRight = false;
  bool isJumping = false;
  bool isAttacking = false;
  bool isOnGround = true;

  // Computed properties
  bool get isMoving => isMovingLeft || isMovingRight;
  bool get isIdle => !isMoving && !isJumping && !isAttacking;

  CharacterState copyWith({
    bool? isMovingLeft,
    bool? isMovingRight,
    bool? isJumping,
    bool? isAttacking,
    bool? isOnGround,
  }) {
    return CharacterState()
      ..isMovingLeft = isMovingLeft ?? this.isMovingLeft
      ..isMovingRight = isMovingRight ?? this.isMovingRight
      ..isJumping = isJumping ?? this.isJumping
      ..isAttacking = isAttacking ?? this.isAttacking
      ..isOnGround = isOnGround ?? this.isOnGround;
  }

  @override
  String toString() => 'CharacterState('
      'left: $isMovingLeft, right: $isMovingRight, '
      'jump: $isJumping, attack: $isAttacking)';
}