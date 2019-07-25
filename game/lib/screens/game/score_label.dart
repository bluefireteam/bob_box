import "dart:ui";
import "dart:math";
import "package:flame/components/component.dart";
import "package:flame/position.dart";
import 'package:flame/text_config.dart';

import "package:vector_math/vector_math.dart";

import "game.dart";

class ScoreLabel extends PositionComponent {

  final TextConfig textConfig = TextConfig(color: const Color(0xFF38607c), fontFamily: "PixelIntv", fontSize: 28);

  final double SPEED = 400;

  final Game _gameRef;
  final String _label;

  ScoreLabel(this._gameRef, this._label) {
    x = _gameRef.player.x;
    y = _gameRef.player.y;
  }

  @override
  void update(double dt) {
    final location = Vector2(x, y);
    final destination = Vector2(_gameRef.controller.scoreCollectionDestination.x, _gameRef.controller.scoreCollectionDestination.y);

    final desired = destination.clone();
    desired.sub(location);
    desired.normalize();

    final s = SPEED * dt;
    x += desired.x * s;
    y += desired.y * s;
  }

  @override
  void render(Canvas canvas) {
    textConfig.render(canvas, "$_label", Position(x, y));
  }

  @override
  bool destroy() {
    final destroyed = y <= _gameRef.controller.scoreCollectionDestination.y;
    return destroyed;
  }
}
