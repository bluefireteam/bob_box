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
  await Flame.audio.load("bob_box.ogg");
  await Flame.init(fullScreen: true, orientation: DeviceOrientation.portraitUp);
  final initialBestScore = await GameData.getScore();
  final initialCoins = await GameData.getCoins();

  runApp(new MaterialApp(
    home: new Scaffold(body: TitleScreen(initialBestScore: initialBestScore, initialCoins: initialCoins)),
    routes: {
    },
  ));

  Flame.util.addGestureRecognizer(TapGestureRecognizer()
    ..onTapDown = (TapDownDetails evt) {
      if (Main.game != null) {
        Main.game.player.stop();
      }
    }
    ..onTapUp = (TapUpDetails evt) {
      if (Main.game != null) {
        Main.game.player.resume();
        Main.game.controller.onTapUp(evt);
      }
    }
  );

  Flame.util.addGestureRecognizer(ImmediateMultiDragGestureRecognizer()
      ..onStart = (Offset) {
        Main.game.player.resume();
        return null;
      }
  );
}
