import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'dart:ui';
import 'dart:math';

import 'game.dart';

class Enemy extends PositionComponent {
  bool _hittedPlayer = false;
  final Game gameRef;

  Sprite _sprite;
  static final Random random = Random();

  Enemy(this.gameRef) {
    width = height = 50;

    _sprite = gameRef.enemiesSpritesheet.getSprite(0, random.nextInt(4));
  }

  @override
  void update(double dt) {
    y += gameRef.currentEnemySpeed * dt;

    if (toRect().overlaps(gameRef.player.toRect())) {
      gameRef.player.hurt();
      gameRef.controller.resetScore();

      _hittedPlayer = true;
    }

    // We only add score when the enemy has died by reaching the bottom of the screen
    if (!_hittedPlayer && destroy()) {
      gameRef.controller.increaseScore();
    }
  }

  @override
  void render(Canvas canvas) {
    _sprite.renderRect(canvas, toRect());
  }

  @override
  bool destroy() {
    return _hittedPlayer || y >= gameRef.size.height;
  }
}
