import 'package:flame/flame.dart';
import 'package:gapless_audio_loop/gapless_audio_loop.dart';

class SoundManager {
  bool soundsEnabled = false;
  GaplessAudioLoop _loopPlayer;
  GaplessAudioLoop _menuPlayer;

  GaplessAudioLoop _lastPlayer;

  bool _isSomethingPlaying = false;

  void init(bool soundsEnabled) async {
    this.soundsEnabled = soundsEnabled;

    _loopPlayer = GaplessAudioLoop();
    await _loopPlayer.load("audio/bob_box_loop.aac");

    _menuPlayer = GaplessAudioLoop();
    await _menuPlayer.load("audio/bob_box_menu.aac");
  }

  void toggleSoundsEnabled() {
    soundsEnabled = !soundsEnabled;

    if (!soundsEnabled) {
      pauseBackgroundMusic();
    } else {
      resumeBackgroundMusic();
    }
  }

  void playLoop() async {
    pauseBackgroundMusic();

    _lastPlayer = _loopPlayer;

    if (soundsEnabled) {
      await _loopPlayer.play();
      _isSomethingPlaying = true;
    }
  }

  void playMenu() async {
    pauseBackgroundMusic();

    _lastPlayer = _menuPlayer;

    if (soundsEnabled) {
      await _menuPlayer.play();
      _isSomethingPlaying = true;
    }
  }

  void resumeBackgroundMusic() async {
    if (soundsEnabled) {
      await _lastPlayer.play();
      _isSomethingPlaying = true;
    }
  }

  void pauseBackgroundMusic() async {
    if (_lastPlayer != null && _isSomethingPlaying) {
      await _lastPlayer.stop();
      _isSomethingPlaying = false;
    }
  }


  void playSfxs(String file) {
    if (soundsEnabled) {
      Flame.audio.play("sfxs/$file.aac");
    }
  }
}
