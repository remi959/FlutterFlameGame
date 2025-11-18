import 'package:flame/components.dart';
import '../components/enemy/enemy_component.dart';

class EnemyAIManager {
  /// Update all enemies with AI logic
  void updateEnemies(Iterable<EnemyComponent> enemies, Vector2 playerPosition) {
    for (final enemy in enemies) {
      enemy.thinkAI(playerPosition);
    }
  }

  void updateEnemiesInRange(
    Iterable<EnemyComponent> enemies,
    Vector2 playerPosition,
    double detectionRange,
  ) {
    for (final enemy in enemies) {
      final distance = (enemy.position - playerPosition).length;
      if (distance <= detectionRange) {
        enemy.thinkAI(playerPosition);
      }
    }
  }

  /// Find enemies that can attack
  Iterable<EnemyComponent> getEnemiesInAttackRange(
    Iterable<EnemyComponent> enemies,
    Vector2 playerPosition,
    double attackRange,
  ) {
    return enemies.where((enemy) {
      final distance = (enemy.position - playerPosition).length;
      return distance <= attackRange;
    });
  }
}