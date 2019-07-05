import 'package:flame/components/component.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/time.dart';
import 'dart:ui';

import './game.dart';

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

enum BobState {
  NEAR_RIGHT,
  NEAR_LEFT,
  BOUNCED,
  IDLE,
  HIT,
}

class Player extends PositionComponent {
  static const PLAYER_SPEED = 200;
  static const NEAR_MARGIN = 80;

  bool _playerMoving = true;
  int _playerDirection = 1;

  final Game gameRef;

  SpriteSheet _spriteSheet;
  Timer _resetStateTimer;

  BobState _state = BobState.IDLE;

  Player(this.gameRef) {
    setByPosition(Position(gameRef.size.width / 2 - 25, gameRef.size.height - 200));
    width = 50;
    height = 50;

    _spriteSheet = SpriteSheet(
      imageName: "bob.png",
      textureWidth: 16,
      textureHeight: 16,
      columns: 5,
      rows: 1,
    );

    _resetStateTimer = Timer(0.4, callback: () {
      _state = BobState.IDLE;
    });
  }

  void stop() {
    _playerMoving = false;
  }

  void resume() {
    _playerMoving = true;
  }

  void hurt() {
    changeState(BobState.HIT);
    resetStateLater();
  }

  Sprite get idle => _spriteSheet.getSprite(0, 0);
  Sprite get nearLeft => _spriteSheet.getSprite(0, 1);
  Sprite get nearRight => _spriteSheet.getSprite(0, 2);
  Sprite get bounced => _spriteSheet.getSprite(0, 3);
  Sprite get hit => _spriteSheet.getSprite(0, 4);

  @override
  void update(double dt) {
    _resetStateTimer.update(dt);
    if (_playerMoving) {
      x += PLAYER_SPEED * dt * _playerDirection;

      final rect = toRect();
      if (rect.left <= 0) {
        setByPosition(Position(0, rect.top));
        _playerDirection = 1;
        changeState(BobState.BOUNCED);
        resetStateLater();
      } else if (_playerDirection == -1 && rect.left <= NEAR_MARGIN) {
        changeState(BobState.NEAR_LEFT);
      }

      final screenSize = gameRef.size;

      if (rect.right >= gameRef.size.width) {
        setByPosition(Position(screenSize.width - rect.width, rect.top));
        _playerDirection = -1;
        changeState(BobState.BOUNCED);
        resetStateLater();
      } else if (_playerDirection == 1 && rect.right >= gameRef.size.width - NEAR_MARGIN) {
        changeState(BobState.NEAR_RIGHT);
      }
    }
  }

  void changeState(BobState state) {
    // When it is hit it can override the other states
    if (state == BobState.HIT) {
      _state = state;
      return;
    }

    // Not started or is finished
    if (_resetStateTimer.current <= 0 || _resetStateTimer.isFinished()) {
      _state = state;
    }
  }

  void resetStateLater() {
    _resetStateTimer.start();
  }

  @override
  void render(Canvas canvas) {
    final rect = toRect();

    if (_state == BobState.IDLE) {
      idle.renderRect(canvas, rect);
    } else if (_state == BobState.NEAR_LEFT) {
      nearLeft.renderRect(canvas, rect);
    } else if (_state == BobState.NEAR_RIGHT) {
      nearRight.renderRect(canvas, rect);
    } else if (_state == BobState.BOUNCED) {
      bounced.renderRect(canvas, rect);
    } else if (_state == BobState.HIT) {
      hit.renderRect(canvas, rect);
    }
  }
}
