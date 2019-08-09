import 'dart:ui';

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

  InGameMessage(this._message) {
    final _painter = _textConfig.toTextPainter(_message);
    width = _painter.width + 10;
    height = _painter.height + 10;

    x = width * -1;
    // TODO this can't be hardecode because of the notch
    y = 100;
  }

  @override
  void update(double dt) {
    if (_appearing) {
      if (x <= 10) {
        x += 400 * dt;
      } else {
        _appearing = false;
        _waiting = true;
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
      x -= 400 * dt;
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
