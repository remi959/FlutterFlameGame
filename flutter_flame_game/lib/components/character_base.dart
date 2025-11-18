import 'package:flame/components.dart';
import '../states/character_cubit.dart';

/// Base class for all characters (Player, Enemy).
/// Behaviours operate on this type, so Player/Enemy stay interchangeable.
///
/// Contains shared movement fields, shared logic hooks, and a CharacterCubit.
abstract class CharacterBase extends PositionComponent {
  Vector2 velocity = Vector2.zero();
  bool isOnGround = true;

  /// Ground level for simple platforming logic.
  double groundY = 300;

  int facingDirection = 1; // 1 = right, -1 = left

  /// All characters use Cubit-driven state (moving/jumping/attacking/etc)
  final CharacterCubit bloc;

  CharacterBase({
    required this.bloc,
    super.position,
    super.size,
  });

  /// All characters (Player & Enemy) will define how an attack works.
  void performAttack();
}