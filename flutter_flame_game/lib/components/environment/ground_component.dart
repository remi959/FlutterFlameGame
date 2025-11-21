import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GroundComponent extends BodyComponent {
  final Vector2 groundSize;
  final Vector2 groundPosition;

  GroundComponent({required this.groundSize, required this.groundPosition});

  @override
  Body createBody() {
    final shape = PolygonShape()
      ..setAsBoxXY(groundSize.x / 2, groundSize.y / 2);

    final fixtureDef = FixtureDef(shape, friction: 0, restitution: 0.0);

    final bodyDef = BodyDef(position: groundPosition, type: BodyType.static);

    final body = world.createBody(bodyDef)..createFixture(fixtureDef);

    // Add user data to identify this as ground
    body.userData = this;

    return body;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    renderBody = false;

    add(
      RectangleComponent(
        size: groundSize,
        position: -groundSize / 2,
        paint: Paint()..color = const Color(0xFF4A4A4A),
      ),
    );
  }
}
