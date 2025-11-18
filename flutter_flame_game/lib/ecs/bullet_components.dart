import 'package:flame/components.dart' show Vector2;
import 'package:oxygen/oxygen.dart' as ox;

/// Bullet world position
class BulletPosition extends ox.Component<BulletPosition> {
  final Vector2 value = Vector2.zero();

  @override
  void init([BulletPosition? fromPool]) {
    // optional: initialize default values
    value.setValues(0, 0);
  }

  @override
  void reset() {
    value.setValues(0, 0);
  }
}

/// Bullet velocity (pixels per second)
class BulletVelocity extends ox.Component<BulletVelocity> {
  final Vector2 value = Vector2.zero();

  @override
  void init([BulletVelocity? fromPool]) {
    value.setValues(0, 0);
  }

  @override
  void reset() {
    value.setValues(0, 0);
  }
}

/// Tag to mark bullet entities
class BulletTag extends ox.Component<BulletTag> {
  @override
  void init([BulletTag? fromPool]) {}

  @override
  void reset() {}
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