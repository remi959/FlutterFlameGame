import 'package:oxygen/oxygen.dart' as ox;

import 'bullet_components.dart';

class BulletPool {
  final ox.World world;
  final List<ox.Entity> _available = [];

  BulletPool(this.world) {
    // Register components once using builder functions
    world
      ..registerComponent(() => BulletPosition())
      ..registerComponent(() => BulletVelocity())
      ..registerComponent(() => BulletTag())
      ..registerComponent(() => BulletActive());

    // Pre-create entities
    const poolSize = 40;
    for (int i = 0; i < poolSize; i++) {
      final e = world.createEntity()
        ..add<BulletPosition, dynamic>()
        ..add<BulletVelocity, dynamic>()
        ..add<BulletTag, dynamic>()
        ..add<BulletActive, dynamic>();

      // e.get<T>() returns T? in 0.3.x, so use !
      e.get<BulletActive>()!.value = false;
      _available.add(e);
    }
  }

  /// Get an inactive bullet entity, or null if exhausted
  ox.Entity? acquire() {
    if (_available.isEmpty) return null;
    return _available.removeLast();
  }

  /// Return bullet to pool and mark as inactive
  void release(ox.Entity e) {
    final active = e.get<BulletActive>();
    if (active != null) {
      active.value = false;
    }
    if (!_available.contains(e)) {
      _available.add(e);
    }
  }
}