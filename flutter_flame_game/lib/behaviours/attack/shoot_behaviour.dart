import '../character_behaviour.dart';
import '../../components/character_base.dart';
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

    final state = character.bloc.state;

    if (state.isAttacking) {
      _fireBulletFromCharacter(character);
      _cooldownTimer = attackCooldown;
      character.bloc.endAttack(); // Clear attack flag
    }
  }

  void _fireBulletFromCharacter(CharacterBase character) {
    final entity = bulletPool.acquire();
    if (entity == null) return;

    final pos = entity.get<BulletPosition>();
    final vel = entity.get<BulletVelocity>();
    final active = entity.get<BulletActive>();

    if (pos == null || vel == null || active == null) return;

    final origin = character.position + character.size / 2;
    pos.value.setFrom(origin);
    vel.value
      ..x = bulletSpeed * character.facingDirection
      ..y = 0;
    active.value = true;
  }
}