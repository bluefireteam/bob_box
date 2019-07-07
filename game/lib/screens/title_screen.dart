import "package:flutter/material.dart";
import "package:flame/flame.dart";

import "game/game.dart";
import "../game_data.dart";
import "../main.dart";

class TitleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> {
  Widget build(BuildContext context) {
    if (Main.game != null) {
      return WillPopScope(
        onWillPop: () async {
          if (Main.game != null) {
            Main.game = null;
            setState(() {});
            return false;
          }
        },
        child: Main.game.widget,
      );
    }

    return Center(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 30),
              RaisedButton(
                  onPressed: () {
                    startGame();
                  },
                  child: const Text(
                      "Play",
                      style: TextStyle(fontSize: 20)
                  ),
              ),
            ],
        ),
    );
  }

  startGame() async {
    final size = await Flame.util.initialDimensions();
    final initialCoins = await GameData.getCoins();

    Main.game = Game(size, initialCoins, () {
      Main.game = null;
      setState(() {});
    });
    setState(() {});
  }
}
