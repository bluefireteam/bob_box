import 'dart:math';
import 'package:flame/time.dart';
import 'package:flame/position.dart';

import 'controller.dart';
import 'enemy.dart';
import 'game.dart';

class EnemyCreator {
  static const INITIAL_ENEMY_SPEED = 100;
  static const ENEMY_SPEED_STEP = 20;
  static const MAX_ENEMY_SPEED = 600;

  static final Random random = Random();


  bool _duplicatedItself = false;
  int currentEnemySpeed = INITIAL_ENEMY_SPEED;

  final Game _gameRef;
  final GameController _controller;

  Timer _enemyCreator;
  Timer _enemySpeedIncreaser;

  EnemyCreator(this._gameRef, this._controller) {
    _enemyCreator = Timer(2.5, repeat: true, callback: () {
      final enemy = Enemy(_gameRef, this);
      enemy.setByPosition(Position(random.nextInt(_gameRef.size.width.toInt() - enemy.width.toInt()).toDouble(), enemy.height * -1));
      _gameRef.add(enemy);
    });
    _enemyCreator.start();

    _enemySpeedIncreaser = Timer(5, repeat: true, callback: () {
      currentEnemySpeed = min(currentEnemySpeed + ENEMY_SPEED_STEP, MAX_ENEMY_SPEED);

      // When we hit the max speed, we create a new enemy creator and reset
      // this instance speed
      if (!_duplicatedItself && currentEnemySpeed == MAX_ENEMY_SPEED) {
        _duplicatedItself = true;

        currentEnemySpeed = INITIAL_ENEMY_SPEED;

        _controller.enemyCreatorsToAdd.add(EnemyCreator(_gameRef, _controller));
      }
    });
    _enemySpeedIncreaser.start();
  }

  void update(double dt) {
    _enemyCreator.update(dt);
    _enemySpeedIncreaser.update(dt);
  }
}
