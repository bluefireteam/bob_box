import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flame/flame.dart';

import 'screens/game/game.dart';

void main() async {
  await Flame.init(fullScreen: true, orientation: DeviceOrientation.portraitUp);

  final size = await Flame.util.initialDimensions();

  final game = Game(size);
  runApp(game.widget);

  Flame.util.addGestureRecognizer(TapGestureRecognizer()
    ..onTapDown = (TapDownDetails evt) {
      game.player.stop();
    }
    ..onTapUp = (TapUpDetails evt) {
      game.player.resume();
    }
  );
}