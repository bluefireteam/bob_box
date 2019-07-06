import 'package:flame/game.dart';
import 'dart:ui';

import 'background.dart';
import 'player.dart';
import 'controller.dart';

import 'spritesheet.dart';

class Game extends BaseGame {
  Player player;
  GameController controller;
  // Lets cache an instance of the SpriteSheet here so we don't need to
  // instantiate another instance upon enemy creation.
  SpriteSheet enemiesSpritesheet;

  static const INITIAL_ENEMY_SPEED = 100;
  static const ENEMY_SPEED_STEP = 20;
  static const MAX_ENEMY_SPEED = 600;

  int currentEnemySpeed = INITIAL_ENEMY_SPEED;

  Game(Size screenSize, int currentCoins) {
    enemiesSpritesheet = SpriteSheet(
      imageName: "enemies.png",
      textureWidth: 16,
      textureHeight: 16,
      columns: 4,
      rows: 1,
    );

    size = screenSize;

    player = Player(this);
    controller = GameController(this, currentCoins);

    add(BackgroundComponent(this));
    add(controller);
    add(player);
  }
}


