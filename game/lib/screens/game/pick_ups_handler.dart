import 'dart:math';
import 'package:flame/time.dart';
import 'package:flame/sprite.dart';
import 'package:flame/components/component.dart';

import "game.dart";
import "coin.dart";

final Random random = Random();

class PickUpsHandler {

  final Game _gameRef;
  Timer _pickUpCreatorTimer;

  PickUpsHandler(this._gameRef) {
    _pickUpCreatorTimer = Timer(5, repeat: true, callback: () {
      if (random.nextDouble() <= 0.4) {
        final r = random.nextDouble();

        if (r <= 0.2) {
          final nugget = GoldNuggetComponent(_gameRef);
          _gameRef.add(nugget);
        }
      }
    });
    _pickUpCreatorTimer.start();
  }

  void update(double dt) {
    _pickUpCreatorTimer.update(dt);
  }

  void _createGoldNuggetPickUp() {
  }
}

class GoldNuggetComponent extends SpriteComponent {
  static double COINS_AMMOUNT = 5;
  static const double SPEED = 150;

  bool _collected = false;

  final Game _gameRef;

  GoldNuggetComponent(this._gameRef) {
    sprite = Sprite("pick-ups.png", width: 16, height: 16);
    width = 50;
    height = 50;
    y = -50;
    x = (_gameRef.size.width * random.nextDouble()) - 50;
  }

  @override
  void update(double dt) {
    super.update(dt);

    y += SPEED * dt;

    if (toRect().overlaps(_gameRef.player.toRect())) {
      _collected = true;

      final double factor = _gameRef.size.width / COINS_AMMOUNT;

      for (var y = 0; y < COINS_AMMOUNT; y++) {
        for (var x = 0; x < COINS_AMMOUNT; x++) {
          _gameRef.add(
              CoinComponent(
                  _gameRef,
                  (x * factor) + (factor * random.nextDouble()),
                  y: (y * factor) + (factor * random.nextDouble()),
              )
          );
        }
      }
    }
  }

  @override
  bool destroy() {
    return _collected || y >= _gameRef.size.height;
  }
}
