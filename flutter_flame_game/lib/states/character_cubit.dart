import 'package:flutter_bloc/flutter_bloc.dart';
import 'character_state.dart';

class CharacterCubit extends Cubit<CharacterState> {
  CharacterCubit() : super(CharacterState());

  void setMovingLeft(bool value) {
    emit(state.copyWith(
      isMovingLeft: value,
      isMovingRight: value ? false : state.isMovingRight,
    ));
  }

  void setMovingRight(bool value) {
    emit(state.copyWith(
      isMovingRight: value,
      isMovingLeft: value ? false : state.isMovingLeft,
    ));
  }

  void startJump() {
    emit(state.copyWith(isJumping: true));
  }

  void endJump() {
    emit(state.copyWith(isJumping: false));
  }

  void startAttack() {
    emit(state.copyWith(isAttacking: true));
  }

  void endAttack() {
    emit(state.copyWith(isAttacking: false));
  }

  void setOnGround(bool value) {
    emit(state.copyWith(isOnGround: value));
  }

  void stopMoving() {
    emit(state.copyWith(isMovingLeft: false, isMovingRight: false));
  }
}