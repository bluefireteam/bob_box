import 'package:flame/flame.dart';
import "package:audioplayers/audioplayers.dart";
import 'package:gapless_audio_loop/gapless_audio_loop.dart';

class SoundManager {
  static bool soundEnabled = false;
  GaplessAudioLoop _backgroundPlayer;

  void init() async {
    _backgroundPlayer = GaplessAudioLoop();
    await _backgroundPlayer.load("audio/bob_box_loop.wav");
  }

  void startBackgroundMusic() async {
    if (soundEnabled)
      await _backgroundPlayer.play();
  }

  void pauseBackgroundMusic() async {
    if (soundEnabled)
      await _backgroundPlayer.stop();
  }
}
