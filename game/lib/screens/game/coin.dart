import "package:flame/components/animation_component.dart";
import "package:flame/animation.dart";

import "game.dart";

class CoinComponent extends AnimationComponent {
  static const double COIN_SPEED = 50;

  Game gameRef;

  bool _collected = false;

  CoinComponent(this.gameRef, double x) : super(30.0, 30.0, new Animation.sequenced("coin.png", 4, textureWidth: 8.0, textureHeight: 8.0)..stepTime = 0.2) {
    this.x = x;
    this.y = -8.0;
  }

  @override
  void update(double dt) {
    super.update(dt);

    y += dt * COIN_SPEED;

    if (toRect().overlaps(gameRef.player.toRect())) {
      gameRef.controller.increaseCoins();
      _collected = true;
    }
  }

  @override
  bool destroy() {
    return _collected || y >= gameRef.size.height;
  }
}
