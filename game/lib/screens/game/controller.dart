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

import 'enemy.dart';
import 'coin.dart';
import 'game.dart';

class Hud {
  double _screenWidth = 0.0;
  Sprite _leftCorner;
  Sprite _rightCorner;
  Sprite _middle;

  Rect _leftRect;
  Rect _rightRect;
  Rect _middleRect;

  Hud(this._screenWidth) {
    _leftCorner = Sprite("hud.png", x: 0, y: 0, width: 16, height: 16);
    _middle = Sprite("hud.png", x: 16, y: 0, width: 16, height: 16);
    _rightCorner = Sprite("hud.png", x: 32, y: 0, width: 16, height: 16);

    _leftRect = Rect.fromLTWH(0, 0, 50, 50);
    _rightRect = Rect.fromLTWH(_screenWidth - 50, 0, 50, 50);

    _middleRect = Rect.fromLTWH(
        _leftRect.right,
        0,
        _rightRect.left - _leftRect.right,
        50
    );
  }

  void render(Canvas canvas) {
    _leftCorner.renderRect(canvas, _leftRect);
    _middle.renderRect(canvas, _middleRect);
    _rightCorner.renderRect(canvas, _rightRect);
  }
}

class GameController extends PositionComponent {
  final TextConfig textConfig = TextConfig(color: const Color(0xFF8bd0ba), fontFamily: "PixelIntv", fontSize: 16);
  final TextConfig pausedTextConfig = TextConfig(color: const Color(0xFF2a2a3a), fontFamily: "PixelIntv", fontSize: 64);

  static final Random random = Random();
  final Game gameRef;
  void Function() _onBack;

  Position _scorePosition;
  Position _coinsPosition;

  Position _pauseButtonPosition;
  Position _backButtonPosition;

  Rect _pauseButtonRect;
  Rect _backButtonRect;

  Position _pauseTextPosition;

  Timer enemyCreator;
  Timer enemySpeedIncreaser;

  Timer coinCreator;

  Hud _hud;

  int _score = 0;
  int _coins = 0;

  GameController(this.gameRef, this._coins, this._onBack) {
    _scorePosition = Position(20, 10);
    _coinsPosition = Position(gameRef.size.width - 240, 10);

    _backButtonRect = Rect.fromLTWH(gameRef.size.width - 20, 10, 20, 20);
    _pauseButtonRect = Rect.fromLTWH(gameRef.size.width - 60, 10, 20, 20);

    _backButtonPosition = Position(_backButtonRect.left, _backButtonRect.top);
    _pauseButtonPosition = Position(_pauseButtonRect.left, _pauseButtonRect.top);

    final o = Offset(gameRef.size.width / 2, gameRef.size.height / 2);
    _pauseTextPosition = Position(o.dx, o.dy);

    enemyCreator = Timer(2.5, repeat: true, callback: () {
      final enemy = Enemy(gameRef);
      enemy.setByPosition(Position(random.nextInt(gameRef.size.width.toInt() - enemy.width.toInt()).toDouble(), enemy.height * -1));
      gameRef.add(enemy);
    });
    enemyCreator.start();

    enemySpeedIncreaser = Timer(5, repeat: true, callback: () {
      gameRef.currentEnemySpeed = min(gameRef.currentEnemySpeed + Game.ENEMY_SPEED_STEP, Game.MAX_ENEMY_SPEED);
    });
    enemySpeedIncreaser.start();

    coinCreator = Timer(4, repeat: true, callback: () {
      if (random.nextDouble() >= 0.6) {
        gameRef.add(CoinComponent(
          gameRef,
          random.nextInt((gameRef.size.width - 8).toInt()).toDouble(),
        ));
      }
    });
    coinCreator.start();

    _hud = Hud(gameRef.size.width);
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

  @override
  void update(double dt) {
    enemyCreator.update(dt);
    enemySpeedIncreaser.update(dt);
    coinCreator.update(dt);
  }

  void resetScore() {
    gameRef.currentEnemySpeed = Game.INITIAL_ENEMY_SPEED;

    _score = 0;
  }

  void increaseScore() {
    _score++;
    GameData.updateScore(_score);
  }

  void increaseCoins() {
    _coins++;
    GameData.updateCoins(_coins);
  }

  @override
  void render(Canvas canvas) {
    _hud.render(canvas);

    textConfig.render(canvas, "Score: $_score", _scorePosition);
    textConfig.render(canvas, "Coins: $_coins", _coinsPosition);

    textConfig.render(canvas, "<", _backButtonPosition);
    if (gameRef.paused) {
      textConfig.render(canvas, ">", _pauseButtonPosition);

      pausedTextConfig.render(canvas, "Paused", _pauseTextPosition, anchor: Anchor.center);
    } else {
      textConfig.render(canvas, "||", _pauseButtonPosition);
    }
  }

  @override
  int priority() => 1;
}
