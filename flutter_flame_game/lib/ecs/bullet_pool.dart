import 'package:oxygen/oxygen.dart' as ox;

import 'bullet_ecs_components.dart';

class BulletPool {
  final ox.World world;
  final List<ox.Entity> _available = [];

  BulletPool(this.world) {
    world
      ..registerComponent(() => BulletActive())
      ..registerComponent(() => BulletPosition())
      ..registerComponent(() => BulletBodyRef())
      ..registerComponent(() => BulletLifetime());

    const poolSize = 40;
    for (int i = 0; i < poolSize; i++) {
      final e = world.createEntity()
        ..add<BulletActive, dynamic>()
        ..add<BulletPosition, dynamic>()
        ..add<BulletBodyRef, dynamic>()
        ..add<BulletLifetime, dynamic>();

      e.get<BulletActive>()!.value = false;
      _available.add(e);
    }
  }

  ox.Entity? acquire() {
    if (_available.isEmpty) return null;
    final e = _available.removeLast();

    final active = e.get<BulletActive>()!;
    final bodyRef = e.get<BulletBodyRef>()!;
    final life = e.get<BulletLifetime>()!;

    active.value = true;
    bodyRef.body = null;
    bodyRef.entity = e;
    bodyRef.pool = this;
    life.age = 0.0;

    return e;
  }

  void release(ox.Entity e) {
    final active = e.get<BulletActive>()!;
    final bodyRef = e.get<BulletBodyRef>()!;
    final life = e.get<BulletLifetime>()!;

    active.value = false;
    life.age = 0.0;

    bodyRef.body?.removeFromParent();
    bodyRef.body = null;
    bodyRef.entity = null;
    bodyRef.pool = null;

    _available.add(e);
  }

  void dispose() {
    for (final e in _available) {
      final bodyRef = e.get<BulletBodyRef>();
      bodyRef?.body?.removeFromParent();
      bodyRef?.body = null;
      bodyRef?.entity = null;
      bodyRef?.pool = null;
    }
    _available.clear();
  }
}