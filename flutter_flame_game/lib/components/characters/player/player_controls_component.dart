import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import '../states/character_cubit.dart';

class PlayerControlsComponent extends Component with KeyboardHandler {
  final CharacterCubit cubit;

  PlayerControlsComponent({required this.cubit});

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is KeyDownEvent;

    if (isKeyDown) {
      if (_isAttackKey(event.logicalKey)) {
        cubit.startAttack();
        return true;
      }
      if (_isJumpKey(event.logicalKey)) {
        cubit.startJump();
        return true;
      }
    }

    _updateMovement(keysPressed);
    
    return false;
  }

  bool _isAttackKey(LogicalKeyboardKey key) {
    return key == LogicalKeyboardKey.keyX || key == LogicalKeyboardKey.enter;
  }

  bool _isJumpKey(LogicalKeyboardKey key) {
    return key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.space;
  }

  void _updateMovement(Set<LogicalKeyboardKey> keysPressed) {
    final left = keysPressed.any((k) => 
      k == LogicalKeyboardKey.arrowLeft || k == LogicalKeyboardKey.keyA);
    final right = keysPressed.any((k) => 
      k == LogicalKeyboardKey.arrowRight || k == LogicalKeyboardKey.keyD);

    if (left && !right) {
      cubit.setMovingLeft(true);
    } else if (right && !left) {
      cubit.setMovingRight(true);
    } else {
      // No movement keys pressed or both pressed - stop moving
      cubit.stopMoving();
    }
  }
}