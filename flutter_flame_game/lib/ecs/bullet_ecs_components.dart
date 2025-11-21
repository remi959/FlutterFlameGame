import 'package:flame/components.dart' show Vector2;
import 'package:oxygen/oxygen.dart' as ox;

import '../components/bullets/bullet_component.dart';
import 'bullet_pool.dart';

/// Bullet world position
class BulletPosition extends ox.Component<BulletPosition> {
  final Vector2 value = Vector2.zero();

  @override
  void init([BulletPosition? fromPool]) {
    value.setValues(0, 0);
  }

  @override
  void reset() {
    value.setValues(0, 0);
  }
}

/// Whether this bullet is currently active in the world
class BulletActive extends ox.Component<BulletActive> {
  bool value = false;

  @override
  void init([BulletActive? fromPool]) {
    value = false;
  }

  @override
  void reset() {
    value = false;
  }
}

class BulletBodyRef extends ox.Component<BulletBodyRef> {
  BulletComponent? body;
  ox.Entity? entity;
  BulletPool? pool;

  @override
  void init([BulletBodyRef? fromPool]) {
    body = null;
    entity = null;
    pool = null;
  }

  @override
  void reset() {
    body = null;
    entity = null;
    pool = null;
  }
}

class BulletLifetime extends ox.Component<BulletLifetime> {
  double age = 0.0;
  double maxLifeTime = 0.0;

  @override
  void init([BulletLifetime? fromPool]) {
    age = 0.0;
    maxLifeTime = 0.0;
  }

  @override
  void reset() {
    age = 0.0;
    maxLifeTime = 0.0;
  }
}