import 'package:flutter/gestures.dart';
import 'package:flame/components/component.dart';
import 'package:flame/text_config.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/time.dart';
import 'package:flame/anchor.dart';
import 'dart:ui';
import 'dart:math';

import '../../game_data.dart';
import '../../scoreboard.dart';
import '../util.dart';
import '../../iap.dart';

import 'enemy_creator.dart';
import 'coin.dart';
import 'pick_ups_handler.dart';
import 'game.dart';
import 'in_game_message.dart';

class Hud {
  double _screenWidth = 0.0;
  Sprite _leftCorner;
  Sprite _rightCorner;
  Sprite _middle;

  Sprite _leftNotch;
  Sprite _rightNotch;

  Rect _leftRect;
  Rect _rightRect;
  Rect _middleRect;

  Rect _leftNotchRect;
  Rect _rightNotchRect;

  Rect _notchFillArea;

  Paint _notchFillPaint = Paint()..color = const Color(0xFF38607c);

  Hud(this._screenWidth) {
    _leftCorner = Sprite("hud.png", x: 0, y: 0, width: 16, height: 16);
    _middle = Sprite("hud.png", x: 16, y: 0, width: 16, height: 16);
    _rightCorner = Sprite("hud.png", x: 32, y: 0, width: 16, height: 16);

    _leftNotch = Sprite("hud.png", x: 48, y: 0, width: 16, height: 16);
    _rightNotch = Sprite("hud.png", x: 64, y: 0, width: 16, height: 16);

    _leftRect = Rect.fromLTWH(0, 0, 50, 50);
    _rightRect = Rect.fromLTWH(_screenWidth - 50, 0, 50, 50);

    _leftNotchRect = Rect.fromLTWH(0, -50, 50, 50);
    _rightNotchRect = Rect.fromLTWH(_screenWidth - 50, -50, 50, 50);

    _middleRect = Rect.fromLTWH(
        _leftRect.right,
        0,
        _rightRect.left - _leftRect.right,
        50
    );

    _notchFillArea = Rect.fromLTWH(0, -100, _screenWidth, 100);
  }

  void render(Canvas canvas) {
    canvas.drawRect(_notchFillArea, _notchFillPaint);
    _leftNotch.renderRect(canvas, _leftNotchRect);
    _rightNotch.renderRect(canvas, _rightNotchRect);

    _leftCorner.renderRect(canvas, _leftRect);
    _middle.renderRect(canvas, _middleRect);
    _rightCorner.renderRect(canvas, _rightRect);
  }
}

class GameController extends PositionComponent {
  final TextConfig textConfig = TextConfig(color: const Color(0xFF8bd0ba), fontFamily: "PixelIntv", fontSize: 16);
  final TextConfig textConfigDark = TextConfig(color: const Color(0xFF38607c), fontFamily: "PixelIntv", fontSize: 16);

  final TextConfig backButtonTextConfig = TextConfig(color: const Color(0xFF8bd0ba), fontFamily: "PixelIntv", fontSize: 26);
  final TextConfig pausedTextConfig = TextConfig(color: const Color(0xFF2a2a3a), fontFamily: "PixelIntv", fontSize: 64);

  static final Random random = Random();
  final Game gameRef;
  void Function() _onBack;

  Position _scorePosition;
  Position _coinsPosition;

  Position get coinsCollectionDestination => _coinsPosition;
  Position get scoreCollectionDestination => _scorePosition;

  Position _pauseButtonPosition;
  Position _backButtonPosition;

  Rect _pauseButtonRect;
  Rect _backButtonRect;

  Position _pauseTextPosition;

  PickUpsHandler _pickUpsHandler;
  List<EnemyCreator> enemyCreators = [];
  List<EnemyCreator> enemyCreatorsToAdd = [];
  Timer coinCreator;

  Timer powerUpTimer;
  PowerUp powerUp;
  Sprite powerUpSprite;

  Position powerUpTimerTextPosition;
  Rect powerUpSpriteRect;
  void Function() powerUpOnFinish;

  Hud _hud;

  int _score = 0;
  int _coins = 0;

  bool _hasBoughtSupport = false;

  int _nextHatPrice;
  bool _newHatMessage = false;

  get score => _score;

  int _lastHighscore = 0;

  GameController(this.gameRef, this._coins, this._onBack) {
    _scorePosition = Position(20, 10);
    _coinsPosition = Position(gameRef.size.width - 240, 10);

    _backButtonRect = Rect.fromLTWH(gameRef.size.width - 30, 6, 20, 50);
    _pauseButtonRect = Rect.fromLTWH(gameRef.size.width - 60, 10, 20, 50);

    _backButtonPosition = Position(_backButtonRect.left, _backButtonRect.top);
    _pauseButtonPosition = Position(_pauseButtonRect.left, _pauseButtonRect.top);

    final o = Offset(gameRef.size.width / 2, gameRef.size.height / 2);
    _pauseTextPosition = Position(o.dx, o.dy);

    print("fetching if user has bought support");
    IAP.hasAlreadyBought().then((value) {
      _hasBoughtSupport = value;
      print("User has bought suppport? $_hasBoughtSupport");
    });

    coinCreator = Timer(4, repeat: true, callback: () {
      for (var i = 0; i < 3; i++) {
        final r = random.nextDouble();
        if (r >= (_hasBoughtSupport ? 0.8 : 0.4)) {
          gameRef.add(CoinComponent(
                  gameRef,
                  random.nextInt((gameRef.size.width - 15).toInt()).toDouble(),
                  special: r > 0.4,
          ));
        }
      }
    });

    enemyCreators.add(EnemyCreator(gameRef, this));
    coinCreator.start();

    _pickUpsHandler = PickUpsHandler(gameRef);
    _hud = Hud(gameRef.size.width);

    GameData.getOwnedHats().then((owned) {
      _nextHatPrice = calcHatPrice(owned.length);
    });

    GameData.getScore().then((score) {
        _lastHighscore = score ?? 0;
    });
  }

  void onTapUp(TapUpDetails evt) {
    final x = evt.globalPosition.dx;
    final y = evt.globalPosition.dy;

    final touchedArea = Rect.fromLTWH(x, y, 20, 20);

    if (touchedArea.overlaps(_backButtonRect)) {
      _onBack();
    } else if (touchedArea.overlaps(_pauseButtonRect)) {
      gameRef.paused = !gameRef.paused;
    }

  }

  void resetPowerUp() {
    if (powerUpOnFinish != null) {
      powerUpOnFinish();
    }
    powerUp = null;
    powerUpTimer = null;
    powerUpSprite = null;
    powerUpSpriteRect = null;
    powerUpOnFinish = null;
  }

  @override
  void update(double dt) {
    _pickUpsHandler.update(dt);

    if (powerUpTimer != null) {
      powerUpTimer.update(dt);
      if (powerUpTimer.isFinished()) {
        resetPowerUp();
      }
    }

    enemyCreators.forEach((creator) {
      creator.update(dt);
    });

    if (enemyCreatorsToAdd.length > 0) {
      enemyCreators.addAll(enemyCreatorsToAdd);
      enemyCreatorsToAdd.clear();
    }

    coinCreator.update(dt);
  }

  void resetScore() async {
      _newHatMessage = false;
      enemyCreators.clear();
      enemyCreators.add(EnemyCreator(gameRef, this));

      if (_score > _lastHighscore) {
          gameRef.add(InGameMessage("New best score!"));
          _lastHighscore = _score;
      }

      ScoreBoard.submit();

      _score = 0;
      resetPowerUp();

      // Remove the current coins
      gameRef.components.forEach((c) {
          if (c is CoinComponent) {
              c.removed = true;
          }
          if (c is PickupComponent) {
              c.removed = true;
          }
      });
  }

  void increaseScore({ score = 1}) {
    _score += score;
    GameData.updateScore(_score);
  }

  void increaseCoins() {
    _coins++;
    GameData.updateCoins(_coins);

    if (!_newHatMessage && _nextHatPrice != null) {
      if (_coins >= _nextHatPrice) {
        gameRef.add(InGameMessage("You can buy a new hat!"));
        _newHatMessage = true;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    _hud.render(canvas);

    textConfig.render(canvas, "Score: $_score", _scorePosition);
    textConfig.render(canvas, "Coins: $_coins", _coinsPosition);

    if (powerUpTimer != null) {
      textConfigDark.render(canvas, "${((1 - powerUpTimer.progress) * 100).toInt()}%", powerUpTimerTextPosition);
      powerUpSprite.renderRect(canvas, powerUpSpriteRect);
    }

    backButtonTextConfig.render(canvas, "<", _backButtonPosition);
    if (gameRef.paused) {
      backButtonTextConfig.render(canvas, ">", Position(_pauseButtonPosition.x, _backButtonPosition.y));

      pausedTextConfig.render(canvas, "Paused", _pauseTextPosition, anchor: Anchor.center);
    } else {
      textConfig.render(canvas, "||", _pauseButtonPosition);
    }
  }

  @override
  int priority() => 1;
}
