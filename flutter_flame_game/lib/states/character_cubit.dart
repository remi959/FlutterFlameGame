import 'package:flutter_bloc/flutter_bloc.dart';
import 'character_state.dart';

class CharacterCubit extends Cubit<CharacterState> {
  CharacterCubit() : super(CharacterState.idle);

  void moveLeft() => emit(CharacterState.movingLeft);
  void moveRight() => emit(CharacterState.movingRight);
  void jump() => emit(CharacterState.jumping);
  void attack() => emit(CharacterState.attacking);
  void idle() => emit(CharacterState.idle);
}
