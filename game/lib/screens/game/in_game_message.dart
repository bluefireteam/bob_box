import 'dart:ui';
import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flame/position.dart';
import 'package:flame/components/component.dart';
import 'package:flame/text_config.dart';

class InGameMessage extends PositionComponent {

  final Paint _backgroundPaint = Paint()..color = const Color(0xFF38607c);
  final Paint _borderPaint = Paint()..color = const Color(0xFF2a2a3a);
  final TextConfig _textConfig = TextConfig(color: const Color(0xFF8bd0ba), fontFamily: "PixelIntv", fontSize: 16);

  String _message;

  bool _appearing = true;
  bool _vanishing = false;
  bool _waiting = false;

  double _waitingTime = 2.0;

  static double SPEED = 800;

  double _travelled = 0.0;

  InGameMessage(this._message) {
    final _painter = _textConfig.toTextPainter(_message);
    width = _painter.width + 10;
    height = _painter.height + 10;

    x = width * -1;
    y = 100;
  }

  @override
  void update(double dt) {
    if (_appearing) {
      if (x <= 10) {
        final _progress = max(0.1, _travelled / (width + 10));
        final _curve = _progress > 1 ? 1 : Curves.easeIn.transformInternal(_progress);

        final _step = SPEED * dt * max(_curve, 0.25);
        _travelled += _step;

        x += _step;
      } else {
        _appearing = false;
        _waiting = true;

        _travelled = 0;
      }
    }

    if (_waiting) {
      _waitingTime -= dt;

      if (_waitingTime <= 0) {
        _waiting = false;
        _vanishing = true;
      }
    }

    if (_vanishing) {
      final _progress = max(0.1, _travelled / width);
      final _curve = _progress > 1 ? 1 : Curves.easeIn.transformInternal(_progress);

      final _step = SPEED * dt * max(_curve, 0.25);

      _travelled += _step;

      x -= _step;
    }
  }

  @override
  void render(Canvas canvas) {
    final r = toRect();
    canvas.drawRect(r.inflate(2.5), _borderPaint);
    canvas.drawRect(r, _backgroundPaint);
    _textConfig.render(canvas, _message, Position(r.left + 5, r.top + 5));
  }

  @override
  int priority() => 1;

  @override
  bool destroy() => _vanishing && x <= width * -1;
}
