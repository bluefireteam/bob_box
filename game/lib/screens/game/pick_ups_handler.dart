import 'dart:ui';
import 'dart:math';
import 'package:flame/time.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/components/component.dart';

import "game.dart";
import "coin.dart";

import "../../main.dart";

final Random random = Random();

class PickUpsHandler {

  final Game _gameRef;
  Timer _pickUpCreatorTimer;

  PickUpsHandler(this._gameRef) {
    _pickUpCreatorTimer = Timer(5, repeat: true, callback: () {
      if (random.nextDouble() <= 0.6) {
        final r = random.nextDouble();

        // TODO plan better the percentage of each pick up
        if (r <= 0.2) {
          _gameRef.add(GoldNuggetComponent(_gameRef));
        } else if (r <= 0.4 && _gameRef.controller.powerUp == null) {
          _gameRef.add(CoffeeComponent(_gameRef));
        } else if (r <= 0.6 && _gameRef.controller.powerUp == null) {
          _gameRef.add(BubbleComponent(_gameRef));
        } else if (r <= 0.8 && _gameRef.controller.powerUp == null) {
          _gameRef.add(MagnetComponent(_gameRef));
        }
      }
    });
    _pickUpCreatorTimer.start();
  }

  void update(double dt) {
    _pickUpCreatorTimer.update(dt);
  }
}

abstract class PickupComponent extends SpriteComponent {
  static const double SPEED = 150;

  bool _collected = false;
  bool removed = false;

  final Game gameRef;

  PickupComponent(this.gameRef) {
    sprite = Sprite("pick-ups.png", width: 16, height: 16, x: _textureX());
    width = 50;
    height = 50;
    y = -50;
    x = (gameRef.size.width - 50) * random.nextDouble();
  }

  double _textureX() => 0.0;
  void _onPickup();

  String _pickupSfx();

  @override
  void update(double dt) {
    super.update(dt);

    y += SPEED * dt;

    if (toRect().overlaps(gameRef.player.toRect())) {
      _collected = true;

      _onPickup();

      if (_pickupSfx() != null) {
        Main.soundManager.playSfxs(_pickupSfx());
      }
    }
  }

  @override
  bool destroy() {
    return removed || _collected || y >= gameRef.size.height;
  }
}

enum PowerUp {
  MAGNET,
  COFFEE,
  BUBBLE,
}

class GoldNuggetComponent extends PickupComponent {
  static double COINS_AMMOUNT = 5;

  GoldNuggetComponent(Game gameRef): super(gameRef);

  @override
  String _pickupSfx() => "Nugget.wav";

  @override
  void _onPickup() {
    final double factor = gameRef.size.width / COINS_AMMOUNT;

    for (var y = 0; y < COINS_AMMOUNT; y++) {
      for (var x = 0; x < COINS_AMMOUNT; x++) {
        gameRef.add(
            CoinComponent(
                gameRef,
                (x * factor) + (factor * random.nextDouble()),
                y: (y * factor) + (factor * random.nextDouble()),
            )
        );
      }
    }
  }
}

abstract class HoldeablePickupComponent extends PickupComponent {
  HoldeablePickupComponent(Game gameRef): super(gameRef);

  double _time();
  PowerUp _powerUp();

  void _onPickup() {
    gameRef.controller.powerUpTimer = Timer(_time())..start();
    gameRef.controller.powerUpSprite = sprite;
    gameRef.controller.powerUpSpriteRect = Rect.fromLTWH(gameRef.size.width - 60, 50, 50, 55);
    gameRef.controller.powerUpTimerTextPosition = Position(gameRef.size.width - 100, 75);
    gameRef.controller.powerUp = _powerUp();
  }
}

class MagnetComponent extends HoldeablePickupComponent {
  MagnetComponent(Game gameRef): super(gameRef);

  @override
  String _pickupSfx() => "Magnet.wav";

  double _textureX() => 16.0;

  double _time() => 120;

  PowerUp _powerUp() => PowerUp.MAGNET;
}

class BubbleComponent extends HoldeablePickupComponent {
  BubbleComponent(Game gameRef): super(gameRef);

  @override
  String _pickupSfx() => null;

  double _textureX() => 48.0;

  double _time() => 10;

  PowerUp _powerUp() => PowerUp.BUBBLE;
}


class CoffeeComponent extends HoldeablePickupComponent {
  CoffeeComponent(Game gameRef): super(gameRef);

  @override
  String _pickupSfx() => null;

  double _textureX() => 32.0;

  double _time() => 15.0;

  PowerUp _powerUp() => PowerUp.COFFEE;
}

