import "package:flutter/material.dart";
import "package:flutter/painting.dart";
import "package:flame/flame.dart";

import "game/game.dart";

import "../ui/button.dart";
import "../ui/label.dart";
import "../ui/background.dart";

import "../game_data.dart";
import "../main.dart";
import "../iap.dart";

class TitleScreen extends StatefulWidget {
  int initialBestScore;
  int initialCoins;

  TitleScreen({ this.initialBestScore, this.initialCoins });

  @override
  State<StatefulWidget> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen>  {
  int _bestScore;
  int _coins;

  bool _loading = false;

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
        child: Background(child: Main.game.widget),
      );
    }

    return Background(
      child: Stack(
              children: <Widget>[
                Positioned(
                    top: 5,
                    right: 0,
                    child: GestureDetector(
                        child: Image(
                            image: AssetImage("assets/images/sound-icon-${Main.soundManager.soundsEnabled ? "on" : "off"}.png"),
                            fit: BoxFit.fill,
                            width: 50,
                            height: 25
                        ),
                        onTap: () {
                          Main.soundManager.toggleSoundsEnabled();
                          GameData.setSoundsEnabled(Main.soundManager.soundsEnabled);
                          // Redraw
                          setState(() {});
                        }
                    )
                ),
                Center(child:
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 10),
                          Image(
                              image: AssetImage("assets/images/title-screen.png"),
                              fit: BoxFit.fill,
                              width: 400,
                              height: 270
                          ),
                          SizedBox(height: 50),
                          Label(label: "Best score: $bestScore"),
                          Label(label: "Current Coins: $totalCoins"),
                          PrimaryButton(label: _loading ? "Loading" : "Play", onPress: () {
                            startGame();
                          }),
                          SecondaryButton(label: "Hats", onPress: () {
                            _menuSfx();
                            Navigator.pushNamed(context, '/hats');
                          }),
                          SecondaryButton(label: "Global Scoreboard", onPress: () {
                            _menuSfx();
                            Navigator.pushNamed(context, '/scoreboard');
                          }),
                          SecondaryButton(label: "Support the game", onPress: () {
                            _menuSfx();
                            Navigator.pushNamed(context, '/support');
                          }),
                          SecondaryButton(label: "Credits", onPress: () {
                            _menuSfx();
                            Navigator.pushNamed(context, '/credits');
                          }),
                        ],
                    ),
                ),
              ]
          ),
    );
  }

  void _menuSfx() {
    Main.soundManager.playSfxs("Select_Menu");
  }

  startGame() async {
    if (_loading) {
      return;
    }

    setState(() {
      _loading = true;
    });

    final size = await Flame.util.initialDimensions();
    final initialCoins = await GameData.getCoins();
    final currentHat = await GameData.getCurrentHat();

    Main.soundManager.playLoop();
    Main.soundManager.playSfxs("UI_Start_Game");
    Main.game = Game(size, initialCoins, currentHat, () {
      Main.soundManager.playMenu();
      onBack();
    });

    setState(() {
      _loading = false;
    });
  }
}
