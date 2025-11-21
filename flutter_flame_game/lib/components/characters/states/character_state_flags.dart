class CharacterStateFlags {
  final bool isMovingLeft;
  final bool isMovingRight;
  final bool isJumping;
  final bool isAttacking;
  final bool isOnGround;

  bool get isMoving => isMovingLeft || isMovingRight;
  bool get isIdle => !isMoving && !isJumping && !isAttacking;

  const CharacterStateFlags({
    this.isMovingLeft = false,
    this.isMovingRight = false,
    this.isJumping = false,
    this.isAttacking = false,
    this.isOnGround = true,
  });

  CharacterStateFlags copyWith({
    bool? isMovingLeft,
    bool? isMovingRight,
    bool? isJumping,
    bool? isAttacking,
    bool? isOnGround,
  }) {
    return CharacterStateFlags(
      isMovingLeft: isMovingLeft ?? this.isMovingLeft,
      isMovingRight: isMovingRight ?? this.isMovingRight,
      isJumping: isJumping ?? this.isJumping,
      isAttacking: isAttacking ?? this.isAttacking,
      isOnGround: isOnGround ?? this.isOnGround,
    );
  }

  @override
  String toString() => 'CharacterState('
      'left: $isMovingLeft, right: $isMovingRight, '
      'jump: $isJumping, attack: $isAttacking, ground: $isOnGround)';
}