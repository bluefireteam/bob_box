import 'package:flame/flame.dart';
import "package:audioplayers/audioplayers.dart";

class SoundManager {
  AudioPlayer _backgroundMusicPlayer;
  Duration _backgorundDuration;

  void init() async {
    await Flame.audio.load("bob_box.wav");
  }

  void startBackgroundMusic() async {
    _backgroundMusicPlayer = await Flame.audio.loopLongAudio("bob_box.wav");
  }

  void pauseBackgroundMusic() async {
    if (_backgroundMusicPlayer == null) return;
    await _backgroundMusicPlayer.pause();
  }

  void resumeBackgroundMusic() async {
    if (_backgroundMusicPlayer == null) return;
    await _backgroundMusicPlayer.resume();
  }
}
