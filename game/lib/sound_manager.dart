import 'package:flame/flame.dart';
import "package:audioplayers/audioplayers.dart";
import 'package:gapless_audio_loop/gapless_audio_loop.dart';

class SoundManager {
  GaplessAudioLoop _backgroundPlayer;

  void init() async {
    _backgroundPlayer = GaplessAudioLoop();
    await _backgroundPlayer.load("audio/bob_box_loop.wav");
  }

  void startBackgroundMusic() async {
    await _backgroundPlayer.play();
  }

  void pauseBackgroundMusic() async {
    await _backgroundPlayer.stop();
  }
}
