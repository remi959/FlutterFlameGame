import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart' as fp;
import 'package:flutter/material.dart';

import '../characters/enemy/enemy_component.dart';
import '../../ecs/bullet_ecs_components.dart';
import '../../ecs/bullet_pool.dart';


class BulletComponent extends BodyComponent with ContactCallbacks {
  final Vector2 spawnPosition;
  final Vector2 initialVelocity;
  final double radius;
  final BulletPool bulletPool;
  final BulletBodyRef bodyRef;
  final int damage;

  BulletComponent({
    required this.spawnPosition,
    required this.initialVelocity,
    required this.bulletPool,
    required this.bodyRef,
    this.radius = 0.1,
    this.damage = 34,
  });

  @override
  Body createBody() {
    final shape = CircleShape()..radius = radius;

    final fixtureDef = FixtureDef(
      shape,
      density: 1.0,
      friction: 0.0,
      restitution: 0.0,
      isSensor: true,
    );

    final bodyDef = BodyDef(
      type: BodyType.dynamic,
      position: spawnPosition,
      bullet: true,
      linearVelocity: initialVelocity,
      fixedRotation: true,
    );

    final body = world.createBody(bodyDef)..createFixture(fixtureDef);
    body.isBullet = true;
    body.gravityScale = Vector2(0, 0);
    body.userData = this; // identify this as bullet component
    return body;
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);

    if (other is EnemyComponent) {
      other.takeDamage(damage);
      impactEffect();

      // recycle ECS entity + body via pool
      final entity = bodyRef.entity;
      if (entity != null && bodyRef.pool != null) {
        bodyRef.pool!.release(entity);
      } else {
        removeFromParent();
      }
    }
  }

  // Create small effect upon bullet impact
  void impactEffect() {
    parent?.add(
      ParticleSystemComponent(
        position: body.position.clone(),
        particle: fp.Particle.generate(
          count: 12,
          lifespan: 0.15,
          generator: (i) {
            final rndDir = (Vector2.random() - Vector2(0.5, 0.5)) * 2;
            return fp.AcceleratedParticle(
              lifespan: 0.15,
              acceleration: -rndDir * 2,
              speed: rndDir * 8,
              child: fp.CircleParticle(
                radius: 0.12,
                paint: Paint()..color = Colors.orange,
              ),
            );
          },
        ),
      ),
    );
  }
}