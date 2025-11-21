import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/rendering.dart';

import '../character_base.dart';
import '../../../game/my_game.dart';
import '../states/character_state_machine.dart';
import '../states/character_states.dart';
import '../character_config.dart';

class EnemyComponent extends CharacterBase {
  final EnemyConfig enemyConfig;

  late CharacterStateMachine stateMachine;

  double _jumpCooldown = 0.0;
  final double jumpCooldownDuration = 1.0;
  
  double _attackCooldown = 0.0;

  EnemyComponent({
    required super.bloc,
    required super.initialPosition,
    EnemyConfig? config,
  }) : enemyConfig = config ?? EnemyConfig.standard,
       super(config: config ?? EnemyConfig.standard);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    renderBody = false;

    // Initialize state machine with config values
    stateMachine = CharacterStateMachine(this);
    stateMachine.changeState(
      IdleCharacterState(this),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update cooldowns
    if (_jumpCooldown > 0) {
      _jumpCooldown -= dt;
    }
    if (_attackCooldown > 0) {
      _attackCooldown -= dt;
    }

    // AI thinks and sets bloc states
    final player = (game as MyGame).player;
    thinkAI(player.body.position);

    // State machine executes based on bloc states
    stateMachine.update(dt);
  }

  @override
  void performAttack() {
    (game as MyGame).player.takeDamage(5);

    _attackCooldown = enemyConfig.attackCooldown;
  }

  bool canAttack() => _attackCooldown <= 0;

  @override
  takeDamage(int damage) {
    super.takeDamage(damage);
    animator.idleSprite.decorator.addLast(
      PaintDecorator.tint(const Color(0xAAFF0000)),
    );
  }

  void thinkAI(Vector2 playerPos) {
    final myPos = body.position;
    final dx = playerPos.x - myPos.x;
    final dy = playerPos.y - myPos.y;

    bloc.stopMoving();

    const attackRangeX = 3;
    const attackRangeY = 2;

    // Only start attack if in range AND cooldown is ready
    if (dx.abs() < attackRangeX && dy.abs() < attackRangeY && canAttack()) {
      bloc.startAttack();
      return;
    }

    if (dx < 0) {
      bloc.setMovingLeft(true);
    } else {
      bloc.setMovingRight(true);
    }

    if (dy < -3 && bloc.state.isOnGround && _jumpCooldown <= 0) {
      bloc.startJump();
      _jumpCooldown = jumpCooldownDuration;
    }
  }

  @override
  void onDeath() {
    (game as MyGame).onEnemyKilled();
    super.onDeath();
  }

  @override
  String getSpritePath() => '/enemy.png';

  String get currentStateName =>
      stateMachine.currentState.runtimeType.toString();
}