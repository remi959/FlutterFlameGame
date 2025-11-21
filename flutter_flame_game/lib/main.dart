import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'game/my_game.dart';
import 'ui/game_over_overlay.dart';
import 'ui/hud_overlay.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final game = MyGame();
    return MaterialApp(
      home: Scaffold(
        body: GameWidget(
          game: game,
          overlayBuilderMap: {
            'HudOverlay': (context, game) => HudOverlay(game: game as MyGame),
            'GameOverOverlay': (context, game) => GameOverOverlay(game: game as MyGame),
          },
          initialActiveOverlays: const ['HudOverlay'],
        ),
      ),
    );
  }
}