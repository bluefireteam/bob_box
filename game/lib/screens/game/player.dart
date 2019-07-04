import 'package:flame/components/component.dart';
import 'package:flame/position.dart';
import 'dart:ui';

import './game.dart';

class Player extends PositionComponent {
  static final Paint black = Paint()..color = Color(0xFF000000);

  static final PLAYER_SPEED = 200;

  bool _playerMoving = true;
  int _playerDirection = 1;

  final Game gameRef;

  Player(this.gameRef) {
    setByPosition(Position(gameRef.size.width / 2 - 25, gameRef.size.height - 200));
    width = 50;
    height = 50;
  }

  void stop() {
    _playerMoving = false;
  }

  void resume() {
    _playerMoving = true;
  }

  void hurt() {
    print('hurt');
  }

  @override
  void update(double dt) {
    if (_playerMoving) {
      x += PLAYER_SPEED * dt * _playerDirection;

      final rect = toRect();
      if (rect.left <= 0) {
        setByPosition(Position(0, rect.top));
        _playerDirection = 1;
      }

      final screenSize = gameRef.size;

      if (rect.right >= gameRef.size.width) {
        setByPosition(Position(screenSize.width - rect.width, rect.top));
        _playerDirection = -1;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(toRect(), black);
  }
}
