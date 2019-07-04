import 'package:flame/game.dart';
import 'dart:ui';

import 'player.dart';
import 'controller.dart';

class Game extends BaseGame {
  Player player;
  GameController controller;

  static const INITIAL_ENEMY_SPEED = 100;
  static const ENEMY_SPEED_STEP = 20;
  static const MAX_ENEMY_SPEED = 600;

  int currentEnemySpeed = INITIAL_ENEMY_SPEED;

  Game(Size screenSize) {
    size = screenSize;

    player = Player(this);
    controller = GameController(this);

    add(controller);
    add(player);
  }
}


