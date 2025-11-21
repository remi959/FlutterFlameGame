import '../character_base.dart';

class CharacterStateMachine {
  final CharacterBase character;
  CharacterState? _currentState;

  CharacterStateMachine(this.character);

  CharacterState? get currentState => _currentState;

  void changeState(CharacterState newState) {
    _currentState?.exit();
    _currentState = newState;
    _currentState?.enter();
  }

  void update(double dt) {

    final nextState = _currentState?.checkTransitions();
    if (nextState != null) {
      changeState(nextState);
    }

    _currentState?.update(dt);
  }
}

abstract class CharacterState {
  final CharacterBase character;

  CharacterState(this.character);

  void enter() {}

  void update(double dt) {}

  void exit() {}

  CharacterState? checkTransitions();
}

