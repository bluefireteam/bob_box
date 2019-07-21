import 'package:flame/flame.dart';
import "package:audioplayers/audioplayers.dart";
import 'package:gapless_audio_loop/gapless_audio_loop.dart';

class SoundManager {
  bool soundsEnabled = false;
  GaplessAudioLoop _backgroundPlayer;

  void init(bool soundsEnabled) async {
    this.soundsEnabled = soundsEnabled;

    _backgroundPlayer = GaplessAudioLoop();
    await _backgroundPlayer.load("audio/bob_box_loop.wav");
  }

  void toggleSoundsEnabled() {
    soundsEnabled = !soundsEnabled;

    if (!soundsEnabled && _backgroundPlayer != null) {
      _backgroundPlayer.stop();
    } else {
      _backgroundPlayer.play();
    }
  }

  void startBackgroundMusic() async {
    if (soundsEnabled)
      await _backgroundPlayer.play();
  }

  void pauseBackgroundMusic() async {
    if (soundsEnabled)
      await _backgroundPlayer.stop();
  }
}
