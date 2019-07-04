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
  int _score = 0;

  GameController(this.gameRef) {
    _background = Rect.fromLTWH(0, 0, gameRef.size.width, gameRef.size.height);

    enemyCreator = Timer(2.5, repeat: true, callback: () {
      print("asd");
      final enemy = Enemy(gameRef);
      enemy.setByPosition(Position(random.nextInt(gameRef.size.width.toInt() - enemy.width.toInt()).toDouble(), enemy.height * -1));
      gameRef.add(enemy);
    });
    enemyCreator.start();
  }

  @override
  void update(double dt) {
    enemyCreator.update(dt);
  }

  void resetScore() {
    _score = 0;
  }

  void increaseScore() {
    _score++;
  }

  @override
  void render(Canvas canvas) {
    // Renders a white background
    canvas.drawRect(_background, white);

    scoreTextConfig.render(canvas, "Score: $_score", _scorePosition);
  }
}
