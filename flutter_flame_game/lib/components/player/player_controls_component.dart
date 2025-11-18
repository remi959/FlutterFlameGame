import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import '../../states/character_cubit.dart';

class PlayerControlsComponent extends Component with KeyboardHandler {
  final CharacterCubit cubit;

  PlayerControlsComponent({required this.cubit});

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is KeyDownEvent;

    // Jump control (check first so it works while moving)
    if (isKeyDown &&
        (event.logicalKey == LogicalKeyboardKey.arrowUp ||
            event.logicalKey == LogicalKeyboardKey.keyW ||
            event.logicalKey == LogicalKeyboardKey.space)) {
      cubit.jump();
      return true;
    }

    // Attack control
    if (isKeyDown &&
        (event.logicalKey == LogicalKeyboardKey.keyX ||
            event.logicalKey == LogicalKeyboardKey.keyJ ||
            event.logicalKey == LogicalKeyboardKey.enter)) {
      cubit.attack();
      return true;
    }

    // Movement controls - check continuously
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA)) {
      cubit.moveLeft();
      return true;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD)) {
      cubit.moveRight();
      return true;
    } else {
      // No movement keys pressed - go idle
      cubit.idle();
    }

    return false;
  }
}