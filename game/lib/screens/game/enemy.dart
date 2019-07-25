import 'package:flame/components/component.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/sprite.dart';
import 'dart:ui';
import 'dart:math';

import 'game.dart';
import 'enemy_creator.dart';
import 'pick_ups_handler.dart';

class Enemy extends PositionComponent {
  bool _hittedPlayer = false;
  final Game gameRef;
  final EnemyCreator _enemyCreator;

  Sprite _sprite;
  static final Random random = Random();

  Enemy(this.gameRef, this._enemyCreator) {
    width = height = 50;

    _sprite = gameRef.enemiesSpritesheet.getSprite(0, random.nextInt(4));
  }

  AnimationComponent _createBottomDeathAnimation() {
    return AnimationComponent.sequenced(50.0, 200.0, "enemy-death.png", 4, textureWidth: 16.0, textureHeight: 64.0, destroyOnFinish: true)
        ..x = x
        ..y = gameRef.size.height - 200;
  }

  AnimationComponent _createPoofDeathAnimation() {
    return AnimationComponent.sequenced(200.0, 200.0, "enemy-death-poof.png", 4, textureWidth: 32.0, textureHeight: 32.0, destroyOnFinish: true)
        ..x = x - 50
        ..y = y - 50;
  }

  @override
  void update(double dt) {
    y += _enemyCreator.currentEnemySpeed * dt;

    if (toRect().overlaps(gameRef.player.toRect())) {
      if (gameRef.controller.powerUp == PowerUp.BUBBLE) {
        gameRef.controller.resetPowerUp();
      } else {
        gameRef.player.hurt();
        gameRef.controller.resetScore();
      }

      _hittedPlayer = true;
      gameRef.add(_createPoofDeathAnimation());
    }

    // We only add score when the enemy has died by reaching the bottom of the screen
    if (!_hittedPlayer && destroy()) {
      gameRef.add(_createBottomDeathAnimation());
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
