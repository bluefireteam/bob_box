import 'package:flame/sprite.dart';

class SpriteSheet {
  String imageName;
  int textureWidth;
  int textureHeight;
  int columns;
  int rows;

  List<List<Sprite>> _sprites;

  SpriteSheet({ this.imageName, this.textureWidth, this.textureHeight, this.columns, this.rows }) {
    _sprites = List.generate(rows, (y) => List.generate(columns, (x) =>
      Sprite(
        imageName,
        x: (x * textureWidth).toDouble(),
        y: (y * textureHeight).toDouble(),
        width: textureWidth.toDouble(),
        height: textureHeight.toDouble()
      ))
    );
  }

  Sprite getSprite(int row, int column) => _sprites[row][column];
}
