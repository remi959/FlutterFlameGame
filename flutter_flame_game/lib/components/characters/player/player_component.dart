import 'package:flame/components.dart';

import '../../../game/my_game.dart';
import '../../../ecs/bullet_pool.dart';
import '../character_base.dart';
import '../character_config.dart';
import '../states/character_state_machine.dart';
import '../states/character_states.dart';
import '../states/player_states.dart';

class PlayerComponent extends CharacterBase {
  final BulletPool bulletPool;
  final PlayerConfig playerConfig;

  late CharacterStateMachine stateMachine;

  PlayerComponent({
    required super.bloc,
    required this.bulletPool,
    required super.initialPosition,
    PlayerConfig? config,
  }) : playerConfig = config ?? PlayerConfig.standard,
       super(config: config ?? PlayerConfig.standard);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    renderBody = false;

    // Initialize state machine with config values
    stateMachine = CharacterStateMachine(this);
    stateMachine.changeState(IdleCharacterState(this));
  }

  @override
  void update(double dt) {
    super.update(dt);

    final current = stateMachine.currentState;
    if (current != null &&
        current is! AttackCharacterState &&
        bloc.state.isAttacking) {
      stateMachine.changeState(
        PlayerShootAttackState(
          this,
          bulletPool: bulletPool,
          bulletSpeed: playerConfig.bulletSpeed,
          bulletLifeTime: playerConfig.bulletLifeTime,
          moveSpeed: playerConfig.moveSpeed,
        ),
      );
    }

    stateMachine.update(dt);
  }

  @override
  void performAttack() {
    (game as MyGame).audioManager.playSfx('shoot.mp3');
    animator.playAttack();
  }

  @override
  takeDamage(int damage) {
    super.takeDamage(damage);
    (game as MyGame).updatePlayerHealth(health, maxHealth);
  }

  @override
  void onDeath() {
    (game as MyGame).onPlayerDied();
  }

  @override
  String getSpritePath() => 'player.png';

  @override
  String? getAttackAnimationPath() => 'sprite_sheets/player_attack.png';

  @override
  int getAttackFrameCount() => 13;

  @override
  double getAttackStepTime() => 0.04;

  @override
  Vector2 getAttackFrameSize() => Vector2.all(32);

  String get currentStateName =>
      stateMachine.currentState.runtimeType.toString();
}
