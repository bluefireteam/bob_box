import "package:flutter/material.dart";
import 'package:flutter/animation.dart';
import 'package:flame/components/component.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/time.dart';
import 'package:flame/game.dart' as FlameGame;
import 'dart:ui';
import 'dart:math';

import 'spritesheet.dart';
import 'hats.dart';
import 'game.dart';
import 'pick_ups_handler.dart';
import 'score_label.dart';

import '../../main.dart';

enum BobState {
  NEAR_RIGHT,
  NEAR_LEFT,
  BOUNCED,
  IDLE,
  HIT,
  BEEN_HOLD,
}

class ResumeableTimer extends Timer {
  ResumeableTimer(double limit, { bool repeat = false, void Function() callback }) : super(limit, repeat: repeat, callback: callback);

  void startOn(double current) {
    super.start();
    super.update(current);
  }
}

class Player extends PositionComponent {
  static const PLAYER_SPEED = 200;
  static const COFFEE_PLAYER_SPEED = 400;
  static const NEAR_MARGIN = 80;

  static const ORIGINAL_SIZE = 50.0;
  static const GROW_RATE = 1.5;
  static const SHRUNK_RATE = 0.5;


  static double HOLDING_LIMIT = 3;

  static final Random random = Random();

  bool _playerMoving = true;
  int _playerDirection = 1;

  final FlameGame.BaseGame gameRef;

  HatSprite _hatSprite;

  SpriteSheet _spriteSheet;
  Timer _resetStateTimer;
  ResumeableTimer _holdingTimer;

  double _holdingCooldown = 0.0;

  BobState _state = BobState.IDLE;

  final _bubblePaint = Paint()..color = const Color(0x9938607c);

  bool hasBubble = false;

  bool _isShrunk = false;
  bool _isGrowed = false;

  Sprite _bubbleSpriteCache;
  get _bubbleSprite {
    if (_bubbleSpriteCache == null) {
      _bubbleSpriteCache = powerUpSprite(PowerUp.BUBBLE);
    }

    return _bubbleSpriteCache;
  }

  Player(this.gameRef, { Hat hat = null }) {

    if (hat != null) {
      _hatSprite = HatSprite(hat, image: Main.hats);
    }

    setByPosition(Position(gameRef.size.width / 2 - 25, gameRef.size.height - 200));
    width = ORIGINAL_SIZE;
    height = ORIGINAL_SIZE;

    _spriteSheet = SpriteSheet(
      image: Main.bob,
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

    _holdingTimer = ResumeableTimer(HOLDING_LIMIT, callback: () {
      resume();
    });
  }

  void stop() {
    _playerMoving = false;
    _holdingTimer.startOn(_holdingCooldown);
    changeState(BobState.BEEN_HOLD);
  }

  void resume() {
    _playerMoving = true;

    _holdingCooldown = _holdingTimer.current;
    _holdingTimer.stop();

    changeState(BobState.IDLE);
  }

  void hurt() {
    final game = gameRef as Game;
    game.addLater(ScoreLabel(game, '-${game.controller.score}'));

    changeState(BobState.HIT);
    resetStateLater();
  }

  Sprite get idle => _spriteSheet.getSprite(0, 0);
  Sprite get nearLeft => _spriteSheet.getSprite(0, 1);
  Sprite get nearRight => _spriteSheet.getSprite(0, 2);
  Sprite get bounced => _spriteSheet.getSprite(0, 3);
  Sprite get hit => _spriteSheet.getSprite(0, 4);
  Sprite get beenHold => _spriteSheet.getSprite(0, 5);

  bool _hasCoffee() => gameRef is Game && (gameRef as Game).controller.powerUp == PowerUp.COFFEE;

  void _increaseScore() {
    if (gameRef is Game) {
      final game = (gameRef as Game);

      final score = _isGrowed ? 4 : 1;

      game.controller.increaseScore(score: score);
      game.addLater(ScoreLabel(game, '+$score'));
    }
  }

  void grow() {
    _isGrowed = true;

    final newSize = ORIGINAL_SIZE * GROW_RATE;
    x -= newSize / 2;
    y -= newSize / 2;

    width = newSize;
    height = newSize;
  }

  void resetGrow() {
    _isGrowed = false;

    final newSize = ORIGINAL_SIZE * GROW_RATE;
    x += newSize / 2;
    y += newSize / 2;

    width = ORIGINAL_SIZE;
    height = ORIGINAL_SIZE;
  }

  void shrink() {
    _isShrunk = true;

    final newSize = ORIGINAL_SIZE * SHRUNK_RATE;
    x -= newSize / 2;
    y -= newSize / 2;

    width = newSize;
    height = newSize;
  }

  void resetShrink() {
    _isShrunk = false;

    final newSize = ORIGINAL_SIZE * SHRUNK_RATE;
    x += newSize / 2;
    y += newSize / 2;

    width = ORIGINAL_SIZE;
    height = ORIGINAL_SIZE;
  }

  @override
  void update(double dt) {
    _resetStateTimer.update(dt);
    _holdingTimer.update(dt);

    if (_holdingCooldown > 0) {
      _holdingCooldown = max(0, _holdingCooldown - dt);
    }

    if (_playerMoving) {
      x += (_hasCoffee() ? COFFEE_PLAYER_SPEED : PLAYER_SPEED) * dt * _playerDirection;

      final rect = toRect();
      if (rect.left <= 0) {
        _increaseScore();
        setByPosition(Position(0, rect.top));
        _playerDirection = 1;
        changeState(BobState.BOUNCED);
        resetStateLater();
      } else if (_playerDirection == -1 && rect.left <= NEAR_MARGIN) {
        changeState(BobState.NEAR_LEFT);
      }

      final screenSize = gameRef.size;

      if (rect.right >= gameRef.size.width) {
        _increaseScore();
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

    if (_hatSprite != null) {
      _hatSprite.render(canvas, rect.left, rect.top, _isGrowed, _isShrunk);
    }

    if (hasBubble) {
       _bubbleSprite.renderRect(canvas, rect.inflate(25), _bubblePaint);
    }
  }
}
