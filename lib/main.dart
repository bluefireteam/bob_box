import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/flame.dart';
import 'package:flame/text_config.dart';
import 'package:flame/position.dart';

void main() async {
  final size = await Flame.util.initialDimensions();

  final game = BounceBoxGame(size);
  runApp(game.widget);

  Flame.util.addGestureRecognizer(TapGestureRecognizer()
    ..onTapDown = (TapDownDetails evt) {
      game.tapDown();
    }
    ..onTapUp = (TapUpDetails evt) {
      game.tapUp();
    }
  );
}

class BounceBoxGame extends Game {
  static final Paint white = Paint()..color = Color(0xFFFFFFFF);
  static final Paint black = Paint()..color = Color(0xFF000000);

  final TextConfig scoreTextConfig = TextConfig(color: const Color(0xFF000000));

  static final Random random = Random();

  static final PLAYER_SPEED = 200;
  bool _playerMoving = true;
  int _playerDirection = 1;
  Rect _player;

  List<Rect> _enemies = [];

  int _score = 0;
  Size screenSize;

  double _timer = 0;

  BounceBoxGame(this.screenSize) {
    _player = Rect.fromLTWH(screenSize.width / 2 - 25, screenSize.height - 200, 50, 50);
  }

  void tapDown() {
    _playerMoving = false;
  }

  void tapUp() {
    _playerMoving = true;
  }

  @override
  void update(double dt) {
    _timer += dt;

    if (_timer >= 2.5) {
      _timer = 0;

      _enemies.add(Rect.fromLTWH(random.nextInt(screenSize.width.toInt() - 50).toDouble(), -25, 50, 50));
    }

    if (_playerMoving) {
      _player = _player.translate(PLAYER_SPEED * dt * _playerDirection, 0);

      if (_player.left <= 0) {
        _player = Rect.fromLTWH(0, _player.top, _player.width, _player.height);
        _playerDirection = 1;
      }

      if (_player.right >= screenSize.width) {
        _player = Rect.fromLTWH(screenSize.width - _player.width, _player.top, _player.width, _player.height);
        _playerDirection = -1;
      }
    }

    for (var i = 0; i < _enemies.length; i++) {
      final e = _enemies[i];

      _enemies[i] = e.translate(0, 100 * dt);

      if (_enemies[i].overlaps(_player)) {
        _enemies.removeAt(i);
        _score = 0;
      }

      if (_enemies[i].top >= screenSize.height) {
        _enemies.removeAt(i);
        _score++;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    // Renders a white background
    canvas.drawRect(Rect.fromLTWH(0, 0, screenSize.width, screenSize.height), white);

    scoreTextConfig.render(canvas, "Score: $_score", Position(10, 50));

    canvas.drawRect(_player, black);

    _enemies.forEach((e) {
      canvas.drawRect(e, black);
    });
  }
}
