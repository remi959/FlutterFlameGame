import 'package:flame_forge2d/flame_forge2d.dart';

import '../../game/my_game.dart';
import '../environment/ground_component.dart';
import 'character_animator.dart';
import 'character_config.dart';
import 'states/character_cubit.dart';

/// Base class for all characters with Forge2D physics
abstract class CharacterBase extends BodyComponent with ContactCallbacks {
  final CharacterCubit bloc;
  final CharacterConfig config;
  final Vector2 initialPosition;

  int _facingDirection = 1;
  late int health;
  late int maxHealth;

  late CharacterAnimator animator;

  Vector2 get characterSize => config.size;
  bool get isAlive => health > 0;
  bool get isOnGround => bloc.state.isOnGround;

  int get facingDirection => _facingDirection;
  set facingDirection(int value) {
    if (_facingDirection != value) {
      _facingDirection = value;
      animator.flipHorizontally();
    }
  }

  CharacterBase({
    required this.bloc,
    required this.config,
    required this.initialPosition,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    maxHealth = config.maxHealth;
    health = maxHealth;

    animator = CharacterAnimator(
      characterSize: config.size,
      idleSpritePath: getSpritePath(),
      attackAnimationPath: getAttackAnimationPath(),
      attackFrameCount: getAttackFrameCount(),
      attackStepTime: getAttackStepTime(),
      frameSize: getAttackFrameSize(),
    );
    await add(animator);
  }

  @override
  Body createBody() {
    final shape = PolygonShape()
      ..setAsBox(characterSize.x / 2, characterSize.y / 2, Vector2.zero(), 0);

    final fixtureDef = FixtureDef(
      shape,
      density: 1,
      friction: 0.5,
      restitution: 0.0,
    );

    final bodyDef = BodyDef(
      position: initialPosition,
      type: BodyType.dynamic,
      fixedRotation: true,
    );

    final body = world.createBody(bodyDef)..createFixture(fixtureDef);
    body.userData = this;

    return body;
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is GroundComponent) {
      bloc.setOnGround(true);
    }
  }

  @override
  void endContact(Object other, Contact contact) {
    super.endContact(other, contact);
    if (other is GroundComponent) {
      bloc.setOnGround(false);
    }
  }

  

  void takeDamage(int damage) {
    health -= damage;
    (game as MyGame).audioManager.playSfx('hit.mp3');
    animator.playDamageFlash();

    if (health <= 0) {
      health = 0;
    }
  }

  void onDeath() {
    removeFromParent();
  }

  // Abstract methods for child classes to override
  String getSpritePath();
  String? getAttackAnimationPath() => null;
  int getAttackFrameCount() => 1;
  double getAttackStepTime() => 0.1;
  Vector2 getAttackFrameSize() => Vector2.all(64);
  void performAttack();
}
