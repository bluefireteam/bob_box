import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flame/flame.dart";
import "package:audioplayers/audioplayers.dart";

import "game/game.dart";

import "../ui/button.dart";
import "../ui/label.dart";
import "../ui/background.dart";

import "../game_data.dart";
import "../main.dart";

class TitleScreen extends StatefulWidget {
  int initialBestScore;
  int initialCoins;

  TitleScreen({ this.initialBestScore, this.initialCoins });

  @override
  State<StatefulWidget> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> with WidgetsBindingObserver  {
  int _bestScore;
  int _coins;

  int get bestScore => _bestScore ??  widget.initialBestScore ?? 0;
  int get totalCoins => _coins ??  widget.initialCoins;

  AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (_audioPlayer != null) {
        _audioPlayer.pause();
      }
    }

    if (state == AppLifecycleState.resumed) {
      if (_audioPlayer != null) {
        _audioPlayer.resume();
      }
    }
  }

  void onBack() async {
    Main.game = null;

    if (_audioPlayer != null) {
      _audioPlayer.stop();
    }

    final score = await GameData.getScore();
    final coins = await GameData.getCoins();
    setState(() {
      _bestScore = score;
      _coins = coins;
    });
  }

  Widget build(BuildContext context) {
    if (Main.game != null) {
      return WillPopScope(
        onWillPop: () async {
          if (Main.game != null) {
            onBack();
            return false;
          }
        },
        child: Main.game.widget,
      );
    }

    return Background(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 200),
            Label(label: "Best score: $bestScore"),
            Label(label: "Current Coins: $totalCoins"),
            PrimaryButton(label: "Play", onPress: () {
              startGame();
            }),
            SecondaryButton(label: "Hats", onPress: () {
              Navigator.pushNamed(context, '/hats');
            }),
            SecondaryButton(label: "Support the game", onPress: () {
            }),
            SecondaryButton(label: "Credits", onPress: () {
            }),
          ],
        ),
      )
    );
  }

  startGame() async {
    if (_audioPlayer != null) {
      _audioPlayer.stop();
    }

    _audioPlayer = await Flame.audio.loopLongAudio("bob_box.mp3");
    final size = await Flame.util.initialDimensions();
    final initialCoins = await GameData.getCoins();
    final currentHat = await GameData.getCurrentHat();

    Main.game = Game(size, initialCoins, currentHat, () {
      onBack();
    });
    setState(() {});
  }
}
