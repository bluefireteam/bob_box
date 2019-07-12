import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flame/flame.dart";

import "game/game.dart";

import "../ui/button.dart";
import "../ui/label.dart";

import "../game_data.dart";
import "../main.dart";

class TitleScreen extends StatefulWidget {
  int initialBestScore;
  int initialCoins;

  TitleScreen({ this.initialBestScore, this.initialCoins });

  @override
  State<StatefulWidget> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> {
  int _bestScore;
  int _coins;

  int get bestScore => _bestScore ??  widget.initialBestScore ?? 0;
  int get totalCoins => _coins ??  widget.initialCoins;

  void onBack() async {
    Main.game = null;

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

    return Container(
      decoration: BoxDecoration(color: Color(0xFFfff8c0)),
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
            SecondaryButton(label: "Store", onPress: () {
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
    final size = await Flame.util.initialDimensions();
    final initialCoins = await GameData.getCoins();

    Main.game = Game(size, initialCoins, () {
      onBack();
    });
    setState(() {});
  }
}
