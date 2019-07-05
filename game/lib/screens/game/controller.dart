import 'package:flame/components/component.dart';
import 'package:flame/text_config.dart';
import 'package:flame/position.dart';
import 'package:flame/time.dart';
import 'dart:ui';
import 'dart:math';

import './enemy.dart';
import './game.dart';

class GameController extends PositionComponent {
  static final Paint white = Paint()..color = Color(0xFFFFFFFF);
  static final Paint black = Paint()..color = Color(0xFF000000);

  final TextConfig scoreTextConfig = TextConfig(color: const Color(0xFF000000));

  static final Random random = Random();
  final Game gameRef;

  Rect _background;
  Position _scorePosition = Position(10, 50);

  Timer enemyCreator;
  Timer enemySpeedIncreaser;

  int _score = 0;

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
  }

  @override
  void update(double dt) {
    enemyCreator.update(dt);
    enemySpeedIncreaser.update(dt);
  }

  void resetScore() {
    gameRef.currentEnemySpeed = Game.INITIAL_ENEMY_SPEED;
    _score = 0;
  }

  void increaseScore() {
    _score++;
  }

  @override
  void render(Canvas canvas) {
    scoreTextConfig.render(canvas, "Score: $_score", _scorePosition);
  }
}
