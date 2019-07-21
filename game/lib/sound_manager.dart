import 'package:flame/flame.dart';
import "package:audioplayers/audioplayers.dart";
import 'package:gapless_audio_loop/gapless_audio_loop.dart';

class SoundManager {
  bool soundsEnabled = false;
  GaplessAudioLoop _loopPlayer;
  GaplessAudioLoop _menuPlayer;

  GaplessAudioLoop _lastPlayer;

  void init(bool soundsEnabled) async {
    this.soundsEnabled = soundsEnabled;

    _loopPlayer = GaplessAudioLoop();
    await _loopPlayer.load("audio/bob_box_loop.wav");

    _menuPlayer = GaplessAudioLoop();
    await _menuPlayer.load("audio/bob_box_menu.wav");
  }

  void toggleSoundsEnabled() {
    soundsEnabled = !soundsEnabled;

    if (!soundsEnabled && _loopPlayer != null) {
      pauseBackgroundMusic();
    } else {
      resumeBackgroundMusic();
    }
  }

  void playLoop() async {
    pauseBackgroundMusic();

    _lastPlayer = _loopPlayer;

    if (soundsEnabled)
      await _loopPlayer.play();
  }

  void playMenu() async {
    pauseBackgroundMusic();

    _lastPlayer = _menuPlayer;

    if (soundsEnabled)
      await _menuPlayer.play();
  }

  void resumeBackgroundMusic() async {
    if (soundsEnabled) 
      await _lastPlayer.play();
  }

  void pauseBackgroundMusic() async {
    if (soundsEnabled)
      await _lastPlayer.stop();
  }
}
