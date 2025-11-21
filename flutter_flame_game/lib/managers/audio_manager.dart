import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  bool _musicEnabled = true;
  bool _sfxEnabled = true;
  String? _currentMusic;

  Future<void> init() async {
    await FlameAudio.audioCache.loadAll([
      'background_music.wav',
      'shoot.mp3',
      'hit.mp3',
    ]);
  }

  void playMusic(String file, {double volume = 0.6}) {
    if (!_musicEnabled) return;
    if (_currentMusic == file) return;
    stopMusic();
    FlameAudio.bgm.play(file, volume: volume);
    _currentMusic = file;
  }

  void stopMusic() {
    FlameAudio.bgm.stop();
    _currentMusic = null;
  }

  void pauseMusic() => FlameAudio.bgm.pause();
  void resumeMusic() => FlameAudio.bgm.resume();

  void playSfx(String file, {double volume = 1.0}) {
    if (!_sfxEnabled) return;
    FlameAudio.play(file, volume: volume);
  }

  void setMusicEnabled(bool enabled) {
    _musicEnabled = enabled;
    if (!enabled) stopMusic();
  }

  void setSfxEnabled(bool enabled) {
    _sfxEnabled = enabled;
  }

  void dispose() {
    stopMusic();
  }
}