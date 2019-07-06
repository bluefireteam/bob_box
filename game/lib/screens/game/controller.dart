import 'package:flame/components/component.dart';
import 'package:flame/text_config.dart';
import 'package:flame/position.dart';
import 'package:flame/time.dart';
import 'dart:ui';
import 'dart:math';

import 'enemy.dart';
import 'coin.dart';
import 'game.dart';

class GameController extends PositionComponent {
  static final Paint white = Paint()..color = Color(0xFFFFFFFF);
  static final Paint black = Paint()..color = Color(0xFF000000);

  final TextConfig scoreTextConfig = TextConfig(color: const Color(0xFF000000));

  static final Random random = Random();
  final Game gameRef;

  Rect _background;
  Position _scorePosition = Position(10, 10);
  Position _coinsPosition = Position(10, 30);

  Timer enemyCreator;
  Timer enemySpeedIncreaser;

  Timer coinCreator;

  int _score = 0;
  int _coins = 0;

  GameController(this.gameRef) {
    _background = Rect.fromLTWH(0, 0, gameRef.size.width, gameRef.size.height);

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
    scoreTextConfig.render(canvas, "Score: $_score", _scorePosition);
    scoreTextConfig.render(canvas, "Coins: $_coins", _coinsPosition);
  }
}
