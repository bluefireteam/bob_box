import "dart:math";
import "package:flutter/animation.dart" as FlutterAnimations;

import "package:flame/components/animation_component.dart";
import "package:flame/animation.dart";
import "package:flame/position.dart";

import "package:vector_math/vector_math.dart";

import "game.dart";
import "pick_ups_handler.dart";

class CoinComponent extends AnimationComponent {
  static const double COIN_SPEED = 50;
  static const double MAGNET_COIN_SPEED = 500;
  static const double COLLECTED_COIN_SPEED = 1000;

  static const double COLLECTION_EASE_DURATION = 1.5;

  Game gameRef;

  Position _collectionDestination;
  bool _collected = false;

  bool removed = false;

  double _easeStep = 0;

  CoinComponent(this.gameRef, double x, { y = -30.0 }) : super(30.0, 30.0, new Animation.sequenced("coin.png", 4, textureWidth: 8.0, textureHeight: 8.0)..stepTime = 0.2) {
    this.x = x;
    this.y = y;

    _collectionDestination = gameRef.controller.coinsCollectionDestination;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!_collected) {
      if (gameRef.controller.powerUp == PowerUp.MAGNET && (gameRef.player.y - y) <= 300) {
        final location = Vector2(x, y);
        final destination = Vector2(gameRef.player.x, gameRef.player.y);

        final desired = destination.clone();
        desired.sub(location);
        desired.normalize();

        final s = MAGNET_COIN_SPEED * dt;
        x += desired.x * s;
        y += desired.y * s;
      } else {
        y += dt * COIN_SPEED;
      }

      if (toRect().overlaps(gameRef.player.toRect())) {
        gameRef.controller.increaseCoins();
        _collected = true;
      }
    } else {
      // Move it to the collection destination
      final location = Vector2(x, y);
      final destination = Vector2(_collectionDestination.x, _collectionDestination.y);

      final desired = destination.clone();
      desired.sub(location);
      desired.normalize();

      _easeStep = min(COLLECTION_EASE_DURATION, _easeStep + dt);
      final percent = (_easeStep / COLLECTION_EASE_DURATION);

      final curve = FlutterAnimations.Curves.easeIn.transformInternal(percent);

      final s = (COLLECTED_COIN_SPEED * curve) * dt;
      x += desired.x * s;
      y += desired.y * s;
    }
  }

  @override
  bool destroy() {
    return (_collected && y <= _collectionDestination.y) || y >= gameRef.size.height || removed;
  }
}
