import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

// Character components
import '../components/characters/player/player_component.dart';
import '../components/characters/player/player_controls_component.dart';
import '../components/characters/enemy/enemy_component.dart';
import '../components/characters/states/character_cubit.dart';
import '../components/characters/character_config.dart';

// Environment components
import '../components/environment/ground_component.dart';
import '../components/environment/background_component.dart';
import '../components/environment/parallax_background_component.dart';

// Managers
import '../managers/ecs_manager.dart';
import '../managers/enemy_ai_manager.dart';
import '../managers/enemy_spawn_manager.dart';
import '../managers/audio_manager.dart';

class MyGame extends Forge2DGame with HasKeyboardHandlerComponents {
  late final PlayerComponent player;
  final double zoomFactor;

  // Managers
  late final ECSManager ecsManager;
  late final EnemyAIManager enemyAIManager;
  late final EnemySpawnManager enemySpawnManager;
  late final AudioManager audioManager;

  // HUD ValueNotifiers
  final ValueNotifier<int> playerHealthVN = ValueNotifier<int>(0);
  int playerMaxHealth = 0;

  final ValueNotifier<int> killsVN = ValueNotifier<int>(0);
  final int killsToWin = 5;
  bool lastWin = false;

  late final Vector2 playerSpawn;

  MyGame({this.zoomFactor = 16}) : super(zoom: zoomFactor);

  @override
  Color backgroundColor() => const Color(0xFF2A2A2A);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // --- BACKGROUND ELEMENTS ---

    // Parallax layer back
    await add(
      ParallaxBackgroundComponent(
        imagePath: 'back.png',
        parallaxFactor: 0.2,
        imageSize: Vector2(200, 150),
      ),
    );

    // Parallax layer middle
    await add(
      ParallaxBackgroundComponent(
        imagePath: 'middle.png',
        parallaxFactor: 2,
        imageSize: Vector2(150, 100),
      ),
    );

    // Static background layer front
    final background = BackgroundComponent(
      images: images,
      imagePath: 'front.png',
      tileWidthWorld: 64,
      tileHeightWorld: 36,
    );
    world.add(background);

    // --- CREATE GROUND ---
    final groundHeight = 1.0;
    final groundY = 0.0;

    final ground = GroundComponent(
      groundSize: Vector2(size.x, groundHeight),
      groundPosition: Vector2(size.x / 2, groundY),
    );
    await world.add(ground);

    // --- MANAGERS SETUP ---
    ecsManager = ECSManager();
    ecsManager.initialize(
      this,
      () => world.children.whereType<EnemyComponent>(),
    );

    // Enemy managers
    enemyAIManager = EnemyAIManager();
    enemySpawnManager = EnemySpawnManager(
      game: this,
      spawnInterval: 0.5,
      maxEnemies: 10,
      spawnAreaMin: Vector2(5, groundY - 3),
      spawnAreaMax: Vector2(size.x - 5, groundY - 3),
    );

    // --- PLAYER SETUP ---
    final playerCubit = CharacterCubit();

    final playerConfig = PlayerConfig.standard;
    playerSpawn = Vector2(size.x / 2, groundY - playerConfig.size.y);

    player = PlayerComponent(
      bloc: playerCubit,
      bulletPool: ecsManager.bulletPool,
      initialPosition: playerSpawn,
    );

    add(PlayerControlsComponent(cubit: playerCubit));
    await world.add(player);

    // init HUD values
    playerMaxHealth = player.maxHealth;
    playerHealthVN.value = player.health;
    killsVN.value = 0;

    // Make the camera follow the player body
    camera.viewfinder.position = player.position.clone();
    camera.follow(
      player,
      snap: true, // start exactly on the player
      horizontalOnly: true, // only follow in x direction
    );

    audioManager = AudioManager();
    await audioManager.init();
    audioManager.playMusic('background_music.wav');

    // spawn initial wave
    enemySpawnManager.spawnWave(3);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    ecsManager.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update ECS for bullets
    ecsManager.update(dt);

    // Update spawn manager
    enemySpawnManager.update(dt);

    // Update enemy AI
    final enemies = world.children.whereType<EnemyComponent>();
    enemyAIManager.updateEnemies(enemies, player.body.position);
  }

  void updatePlayerHealth(int health, int max) {
    playerMaxHealth = max;
    playerHealthVN.value = health;
  }

  // Called by EnemyComponent.onDeath
  void onEnemyKilled() {
    final next = killsVN.value + 1;
    killsVN.value = next;
    if (next >= killsToWin) {
      endGame(win: true);
    }
  }

  // Called by PlayerComponent.onDeath
  void onPlayerDied() {
    endGame(win: false);
  }

  void endGame({required bool win}) {
    lastWin = win;
    pauseEngine();
    overlays.add('GameOverOverlay');
  }

  void restartGame() {
    // Hide overlay
    overlays.remove('GameOverOverlay');

    // Clear enemies and reset spawner
    enemySpawnManager.clearAllEnemies();
    enemySpawnManager.reset();

    // Reset counters
    killsVN.value = 0;

    // Reset player state
    player.health = player.maxHealth;
    updatePlayerHealth(player.health, player.maxHealth);
    player.bloc.stopMoving();
    player.body.setTransform(playerSpawn, 0);
    player.body.linearVelocity = Vector2.zero();

    // Resume and spawn a fresh wave
    resumeEngine();
    enemySpawnManager.spawnWave(3);
  }

  @override
  void onRemove() {
    ecsManager.dispose();
    audioManager.dispose();
    playerHealthVN.dispose();
    killsVN.dispose();
    super.onRemove();
  }
}
