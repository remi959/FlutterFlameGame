import 'package:flutter/material.dart';
import '../game/my_game.dart';

class StartOverlay extends StatelessWidget {
  final MyGame game;
  const StartOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            game.overlays.remove('StartOverlay');
            game.audioManager.playMusic('background_music.wav');
            game.resumeEngine();
          },
          child: const Text('Click to Start'),
        ),
      ),
    );
  }
}