import 'package:flame/components/component.dart';
import 'package:flame/text_config.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/time.dart';
import 'dart:ui';
import 'dart:math';

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
  final TextConfig textConfig = TextConfig(color: const Color(0xFF8bd0ba), fontFamily: "PixelIntv");

  static final Random random = Random();
  final Game gameRef;

  Position _scorePosition;
  Position _coinsPosition;

  Timer enemyCreator;
  Timer enemySpeedIncreaser;

  Timer coinCreator;

  Hud _hud;

  int _score = 0;
  int _coins = 0;

  GameController(this.gameRef) {
    _scorePosition = Position(20, 10);
    _coinsPosition = Position(gameRef.size.width - 150, 10);

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

  @override
  void update(double dt) {
    enemyCreator.update(dt);
    enemySpeedIncreaser.update(dt);
    coinCreator.update(dt);
  }

  void resetScore() {
    gameRef.currentEnemySpeed = Game.INITIAL_ENEMY_SPEED;
    _score = 0;
    _coins = 0;
  }

  void increaseScore() {
    _score++;
  }

  void increaseCoins() {
    _coins++;
  }

  @override
  void render(Canvas canvas) {
    _hud.render(canvas);

    textConfig.render(canvas, "Score: $_score", _scorePosition);
    textConfig.render(canvas, "Coins: $_coins", _coinsPosition);
  }

  @override
  int priority() => 1;
}
