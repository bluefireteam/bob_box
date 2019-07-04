import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'dart:ui';

import 'player.dart';
import 'controller.dart';

class Game extends BaseGame {
  Player player;
  GameController controller;

  Game(Size screenSize) {
    size = screenSize;

    player = Player(this);
    controller = GameController(this);

    add(controller);
    add(player);
  }
}


