import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flame/flame.dart';

import 'screens/game/game.dart';
import 'screens/title_screen.dart';

import 'game_data.dart';

class Main {
  static Game game;
}

void main() async {
  await Flame.init(fullScreen: true, orientation: DeviceOrientation.portraitUp);

  runApp(new MaterialApp(
    home: new Scaffold(body: TitleScreen()),
    routes: {
    },
  )); 

  //final size = await Flame.util.initialDimensions();
  //final initialCoins = await GameData.getCoins();

  //final game = Game(size, initialCoins);
  //runApp(game.widget);

  Flame.util.addGestureRecognizer(TapGestureRecognizer()
    ..onTapDown = (TapDownDetails evt) {
      if (Main.game != null) {
        Main.game.player.stop();
      }
    }
    ..onTapUp = (TapUpDetails evt) {
      if (Main.game != null) {
        Main.game.player.resume();
      }
    }
  );
}
