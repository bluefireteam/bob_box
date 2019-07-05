import 'package:flame/components/component.dart';
import 'dart:ui';

import './game.dart';

class Enemy extends PositionComponent {
  static final Paint black = Paint()..color = Color(0xFF000000);

  bool _hittedPlayer = false;
  final Game gameRef;

  Enemy(this.gameRef) {
    width = height = 50;
  }

  @override
  void update(double dt) {
    y += gameRef.currentEnemySpeed * dt;

    if (toRect().overlaps(gameRef.player.toRect())) {
      gameRef.player.hurt();
      gameRef.controller.resetScore();

      _hittedPlayer = true;
    }

    if (destroy()) {
      gameRef.controller.increaseScore();
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(toRect(), black);
  }

  @override
  bool destroy() {
    return _hittedPlayer || y >= gameRef.size.height;
  }
}
