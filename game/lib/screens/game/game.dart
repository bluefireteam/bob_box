import 'package:flame/game.dart';
import 'dart:ui';

import 'background.dart';
import 'player.dart';
import 'controller.dart';
import 'hats.dart';

import 'spritesheet.dart';

import '../../main.dart';

class PauseableGame extends BaseGame {

  bool paused = false;

  @override
  void update(double dt) {
    if (paused) {
      return;
    }

    super.update(dt);
  }
}

class Game extends PauseableGame {
  void Function() _onBack;

  Player player;
  GameController controller;
  // Lets cache an instance of the SpriteSheet here so we don't need to
  // instantiate another instance upon enemy creation.
  SpriteSheet enemiesSpritesheet;

  Game(Size screenSize, int currentCoins, Hat currentHat, bool hasBoughtSupport, this._onBack) {
    enemiesSpritesheet = SpriteSheet(
      image: Main.enemies,
      textureWidth: 16,
      textureHeight: 16,
      columns: 4,
      rows: 1,
    );

    size = screenSize;

    player = Player(this, hat: currentHat);
    controller = GameController(this, currentCoins, hasBoughtSupport, _onBack);

    add(BackgroundComponent(this));
    add(controller);
    add(player);
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      paused = true;
    }
  }
}

