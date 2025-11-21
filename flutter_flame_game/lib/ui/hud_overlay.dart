import 'package:flutter/material.dart';
import '../game/my_game.dart';

class HudOverlay extends StatelessWidget {
  final MyGame game;
  const HudOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Align(
            alignment: Alignment.topLeft,
            child: Row(
              mainAxisSize:
                  MainAxisSize.min, // Makes the Row shrink to fit its children
              children: [
                // Health bar
                ValueListenableBuilder<int>(
                  valueListenable: game.playerHealthVN,
                  builder: (_, health, _) {
                    final max = game.playerMaxHealth;
                    final pct = (max == 0)
                        ? 0.0
                        : (health / max).clamp(0.0, 1.0);
                    return SizedBox(
                      width: 220,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Health: $health/$max',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: pct,
                              minHeight: 12,
                              backgroundColor: Colors.grey.shade800,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                // Kills counter
                ValueListenableBuilder<int>(
                  valueListenable: game.killsVN,
                  builder: (_, kills, _) {
                    return Text(
                      'Enemies: $kills/${game.killsToWin}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
