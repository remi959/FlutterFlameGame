import 'package:flame/components.dart';

import '../../../ecs/bullet_pool.dart';
import '../../../ecs/bullet_ecs_components.dart';
import '../../bullets/bullet_component.dart';
import 'character_states.dart';

/// Player-specific attack state that shoots bullets
class PlayerShootAttackState extends AttackCharacterState {
  final BulletPool bulletPool;
  final double bulletSpeed;
  final double bulletLifeTime;

  PlayerShootAttackState(
    super.character, {
    required this.bulletPool,
    required this.bulletSpeed,
    required this.bulletLifeTime,
    super.moveSpeed = 10,
  });

  @override
  void enter() {
    // Execute attack and shoot bullet
    character.performAttack();
    _shootBullet();
    attackExecuted = true;
    character.bloc.endAttack();
  }

  void _shootBullet() {
    final entity = bulletPool.acquire();
    if (entity == null) return;

    final pos = entity.get<BulletPosition>()!;
    final active = entity.get<BulletActive>()!;
    final bodyRef = entity.get<BulletBodyRef>()!;
    final life = entity.get<BulletLifetime>()!;

    // Calculate spawn position
    final origin = character.body.worldCenter.clone()
      ..y += character.characterSize.y * 0.25
      ..x += character.facingDirection * 0.6;

    final velocity = Vector2(bulletSpeed * character.facingDirection, 0);

    pos.value.setFrom(origin);
    active.value = true;
    life.age = 0.0;
    life.maxLifeTime = bulletLifeTime;

    final bulletBody = BulletComponent(
      spawnPosition: origin,
      initialVelocity: velocity,
      bulletPool: bulletPool,
      bodyRef: bodyRef,
      radius: 0.1,
    );

    character.game.world.add(bulletBody);
    bodyRef.body = bulletBody;
  }
}
