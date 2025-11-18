import '../character_behaviour.dart';
import '../../components/character_base.dart';
import '../../states/character_state.dart';
import '../../ecs/bullet_pool.dart';
import '../../ecs/bullet_components.dart';

class ShootBehaviour implements AttackBehaviour {
  final double attackCooldown;
  final BulletPool bulletPool;
  final double bulletSpeed;

  double _cooldownTimer = 0;

  ShootBehaviour({
    required this.bulletPool,
    this.attackCooldown = 0.25,
    this.bulletSpeed = 500,
  });

  @override
  void update(double dt, CharacterBase character) {
    if (_cooldownTimer > 0) {
      _cooldownTimer -= dt;
      return;
    }

    if (character.bloc.state == CharacterState.attacking) {
      // Let the character do its own attack animation / state change
      character.performAttack();

      // Actually fire a bullet via ECS + pool
      _fireBulletFromCharacter(character);

      _cooldownTimer = attackCooldown;
    }
  }

  void _fireBulletFromCharacter(CharacterBase character) {
    final entity = bulletPool.acquire();
    if (entity == null) return;

    final pos = entity.get<BulletPosition>()!.value;
    final vel = entity.get<BulletVelocity>()!.value;
    final active = entity.get<BulletActive>()!;

    final origin = character.position + character.size / 2;
    pos.setFrom(origin);

    // Shoot based on facing direction field
    vel
      ..x = bulletSpeed * character.facingDirection
      ..y = 0;

    active.value = true;
  }
}
