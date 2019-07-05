import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'dart:ui';

import 'game.dart';

class BackgroundComponent extends Component {
  static const int BACKGROUND_SPEED = 50;

  Game gameRef;

  Sprite _sprite;
  List<Rect> _lines;

  BackgroundComponent(this.gameRef) {
    _load();
  }

  void _load() async {
    _sprite = await Sprite.loadSprite('background-texture.png');

    final w = gameRef.size.width;
    final h = gameRef.size.height;

    final length = (h / w).toInt() + 2;

    _lines = List.generate(length, (n) => Rect.fromLTWH(0, (n - 1) * w, w, w + 1));
  }

  @override
  void update(double dt) {
    if (_lines != null) {
      for (var i = 0; i < _lines.length; i++) {
        _lines[i] = _lines[i].translate(0, BACKGROUND_SPEED * dt);

        if (_lines[i].top >= gameRef.size.height) {
          final w = gameRef.size.width;
          _lines[i] = Rect.fromLTWH(0, w * -1, w, w + 1);
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    _lines.forEach((r) {
      _sprite.renderRect(canvas, r);
    });
  }

  @override
  bool loaded() => _lines != null && _sprite != null && _sprite.loaded();
}
