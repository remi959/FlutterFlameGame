import 'package:flame/components.dart';

import '../components/characters/enemy/enemy_component.dart';

class EnemyAIManager {
  /// Update all enemies with AI logic
  void updateEnemies(Iterable<EnemyComponent> enemies, Vector2 playerPosition) {
    for (final enemy in enemies) {
      enemy.thinkAI(playerPosition);
    }
  }
}
