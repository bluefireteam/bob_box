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

        if (r <= 0.2) {
          _gameRef.add(GoldNuggetComponent(_gameRef));
        } else if (r <= 0.4 && _gameRef.controller.powerUp == null) {
          _gameRef.add(CoffeeComponent(_gameRef));
        } else if (r <= 0.6 && _gameRef.controller.powerUp == null) {
          _gameRef.add(BubbleComponent(_gameRef));
        } else if (r <= 0.8 && _gameRef.controller.powerUp == null) {
          _gameRef.add(MagnetComponent(_gameRef));
        } else if(_gameRef.controller.powerUp == null) {
          final mushroomR = random.nextDouble();
          if (mushroomR >= 0.5) {
            _gameRef.add(GrowMushroomComponent(_gameRef));
          } else {
            _gameRef.add(ShrinkMushroomComponent(_gameRef));
          }
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
    sprite = powerUpSprite(_powerUp());
    width = 50;
    height = 50;
    y = -50;
    x = (gameRef.size.width - 50) * random.nextDouble();
  }

  PowerUp _powerUp();
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
  NUGGET,
  MAGNET,
  COFFEE,
  BUBBLE,
  GROW_MUSHROOM,
  SHRINK_MUSHROOM,
}

Sprite powerUpSprite(PowerUp powerUp) {
  double textureX;

  switch(powerUp) {
    case PowerUp.NUGGET: {
      textureX = 0;
      break;
    }
    case PowerUp.MAGNET: {
      textureX = 16;
      break;
    }
    case PowerUp.COFFEE: {
      textureX = 32;
      break;
    }
    case PowerUp.BUBBLE: {
      textureX = 48;
      break;
    }
    case PowerUp.GROW_MUSHROOM: {
      textureX = 64;
      break;
    }
    case PowerUp.SHRINK_MUSHROOM: {
      textureX = 80;
      break;
    }
  }

  return Sprite("pick-ups.png", width: 16, height: 16, x: textureX);
}

class GoldNuggetComponent extends PickupComponent {
  static double COINS_AMMOUNT = 5;

  GoldNuggetComponent(Game gameRef): super(gameRef);

  @override
  PowerUp _powerUp() => PowerUp.NUGGET;

  @override
  String _pickupSfx() => "Nugget";

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

class BubbleComponent extends PickupComponent {
  BubbleComponent(Game gameRef): super(gameRef);

  @override
  String _pickupSfx() => "Bubble_Shield";

  @override
  PowerUp _powerUp() => PowerUp.BUBBLE;

  @override
  void _onPickup() {
    gameRef.player.hasBubble = true;
  }
}

abstract class HoldeablePickupComponent extends PickupComponent {
  HoldeablePickupComponent(Game gameRef): super(gameRef);

  double _time();

  void Function() _expireCallback() => null;

  void _onPickup() {
    gameRef.controller.powerUpTimer = Timer(_time())..start();
    gameRef.controller.powerUpSprite = sprite;
    gameRef.controller.powerUpSpriteRect = Rect.fromLTWH(gameRef.size.width - 60, 50, 50, 55);
    gameRef.controller.powerUpTimerTextPosition = Position(gameRef.size.width - 100, 75);
    gameRef.controller.powerUp = _powerUp();

    final callback = _expireCallback();

    if (callback != null) {
      gameRef.controller.powerUpOnFinish = callback;
    }
  }
}

class MagnetComponent extends HoldeablePickupComponent {
  MagnetComponent(Game gameRef): super(gameRef);

  @override
  String _pickupSfx() => "Magnet";

  double _time() => 120;

  PowerUp _powerUp() => PowerUp.MAGNET;
}

class CoffeeComponent extends HoldeablePickupComponent {
  CoffeeComponent(Game gameRef): super(gameRef);

  @override
  String _pickupSfx() => "Coffee";

  @override
  double _time() => 15.0;

  @override
  PowerUp _powerUp() => PowerUp.COFFEE;
}

class GrowMushroomComponent extends HoldeablePickupComponent {
  GrowMushroomComponent(Game gameRef): super(gameRef);

  @override
  String _pickupSfx() => "Grow";

  double _time() => 30.0;

  @override
  PowerUp _powerUp() => PowerUp.GROW_MUSHROOM;

  @override
  void _onPickup() {
    super._onPickup();

    gameRef.player.grow();
  }

  @override
  void Function() _expireCallback() => () {
    gameRef.player.resetGrow();
  };
}

class ShrinkMushroomComponent extends HoldeablePickupComponent {
  ShrinkMushroomComponent(Game gameRef): super(gameRef);

  @override
  String _pickupSfx() => "Shrink";

  @override
  double _time() => 30.0;

  @override
  PowerUp _powerUp() => PowerUp.SHRINK_MUSHROOM;

  @override
  void _onPickup() {
    super._onPickup();

    gameRef.player.shrink();
  }

  @override
  void Function() _expireCallback() => () {
    gameRef.player.resetShrink();
  };
}

