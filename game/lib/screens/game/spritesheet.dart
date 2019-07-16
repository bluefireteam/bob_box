import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

class SpriteSheet {
  Image image;
  int textureWidth;
  int textureHeight;
  int columns;
  int rows;

  List<List<Sprite>> _sprites;

  SpriteSheet({ this.image, this.textureWidth, this.textureHeight, this.columns, this.rows }) {
    _sprites = List.generate(rows, (y) => List.generate(columns, (x) =>
      Sprite.fromImage(
        image,
        x: (x * textureWidth).toDouble(),
        y: (y * textureHeight).toDouble(),
        width: textureWidth.toDouble(),
        height: textureHeight.toDouble()
      ))
    );
  }

  Sprite getSprite(int row, int column) => _sprites[row][column];
}
