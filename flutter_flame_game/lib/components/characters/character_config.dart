import 'package:flame/components.dart';

/// Base configuration for all characters
class CharacterConfig {
  final Vector2 size;
  final double moveSpeed;
  final double jumpForce;
  final double attackCooldown;
  final int maxHealth;

  const CharacterConfig({
    required this.size,
    required this.moveSpeed,
    required this.jumpForce,
    required this.attackCooldown,
    required this.maxHealth,
  });
}

/// Player-specific configuration
class PlayerConfig extends CharacterConfig {
  final double bulletSpeed;
  final double bulletLifeTime;

  const PlayerConfig({
    required super.size,
    required super.moveSpeed,
    required super.jumpForce,
    required super.attackCooldown,
    required super.maxHealth,
    required this.bulletSpeed,
    required this.bulletLifeTime,
  });

  // Default player configuration
  static final PlayerConfig standard = PlayerConfig(
    size: Vector2(3, 3),
    moveSpeed: 10.0,
    jumpForce: 60.0,
    attackCooldown: 0.5,
    maxHealth: 50,
    bulletSpeed: 20.0,
    bulletLifeTime: 3.0,
  );
}

/// Enemy-specific configuration
class EnemyConfig extends CharacterConfig {
  final double aiUpdateInterval;

  const EnemyConfig({
    required super.size,
    required super.moveSpeed,
    required super.jumpForce,
    required super.attackCooldown,
    required super.maxHealth,
    this.aiUpdateInterval = 0.1,
  });

  // Default enemy configurations
  static final EnemyConfig standard = EnemyConfig(
    size: Vector2(2, 3),
    moveSpeed: 8.0,
    jumpForce: 60.0,
    attackCooldown: 1.0,
    maxHealth: 30,
  );

  static final EnemyConfig fast = EnemyConfig(
    size: Vector2(2, 3),
    moveSpeed: 12.0,
    jumpForce: 70.0,
    attackCooldown: 0.8,
    maxHealth: 20,
  );

  static final EnemyConfig tank = EnemyConfig(
    size: Vector2(2.5, 3.5),
    moveSpeed: 6.0,
    jumpForce: 50.0,
    attackCooldown: 1.5,
    maxHealth: 60,
  );
}