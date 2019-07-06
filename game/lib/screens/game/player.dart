import 'package:flutter/animation.dart';
import 'package:flame/components/component.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/time.dart';
import 'dart:ui';
import 'dart:math';

import 'spritesheet.dart';
import 'game.dart';


enum BobState {
  NEAR_RIGHT,
  NEAR_LEFT,
  BOUNCED,
  IDLE,
  HIT,
  BEEN_HOLD,
}

class Player extends PositionComponent {
  static const PLAYER_SPEED = 200;
  static const NEAR_MARGIN = 80;

  static double HOLDING_LIMIT = 3;

  static final Random random = Random();

  bool _playerMoving = true;
  int _playerDirection = 1;

  final Game gameRef;

  SpriteSheet _spriteSheet;
  Timer _resetStateTimer;
  Timer _holdingTimer;

  BobState _state = BobState.IDLE;

  Player(this.gameRef) {
    setByPosition(Position(gameRef.size.width / 2 - 25, gameRef.size.height - 200));
    width = 50;
    height = 50;

    _spriteSheet = SpriteSheet(
      imageName: "bob.png",
      textureWidth: 16,
      textureHeight: 16,
      columns: 6,
      rows: 1,
    );

    _resetStateTimer = Timer(0.4, callback: () {
      if (_state != BobState.BEEN_HOLD) {
        changeState(BobState.IDLE);
      }
    });

    // TODO add visual indicator about the holding
    _holdingTimer = Timer(HOLDING_LIMIT, callback: () {
      resume();
    });
  }

  void stop() {
    _playerMoving = false;
    _holdingTimer.start();
    changeState(BobState.BEEN_HOLD);
  }

  void resume() {
    _playerMoving = true;
    _holdingTimer.stop();
    changeState(BobState.IDLE);
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
  Sprite get beenHold => _spriteSheet.getSprite(0, 5);

  @override
  void update(double dt) {
    _resetStateTimer.update(dt);
    _holdingTimer.update(dt);

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
    // When it is hit or been hold it can override the other states
    if (state == BobState.HIT || state == BobState.BEEN_HOLD) {
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

  double randomModifier() => random.nextBool() ? 4.0 : -4.0;

  @override
  void render(Canvas canvas) {
    var rect = toRect();

    if (!_playerMoving) {
      final curve = Curves.easeIn.transformInternal(_holdingTimer.current / HOLDING_LIMIT);

      rect = rect.translate(
          randomModifier() * curve,
          randomModifier() * curve,
      );
    }

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
    } else if (_state == BobState.BEEN_HOLD) {
      beenHold.renderRect(canvas, rect);
    }
  }
}