import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:illume/src/components/game_object.dart';
import 'package:illume/src/extensions.dart';

import 'components/collision.dart';

/// The controller for the game which contains the game objects and allows
/// controlling the start/stop/pause mechanism for the game
class IllumeController extends ValueNotifier<List<GameObject>> {
  /// Game objects present in the game
  late List<GameObject> gameObjects;

  /// Create default [IllumeController]
  factory IllumeController() => IllumeController._([]);

  /// Create [IllumeController] from game objects
  factory IllumeController.fromObjects(List<GameObject> objects) =>
      IllumeController._(objects);

  IllumeController._(this.gameObjects) : super(gameObjects) {
    _ticker = Ticker(_update);
  }

  DateTime? gameLoopStart;
  DateTime? lastTick;
  late Ticker _ticker;

  ValueChanged<GameObject>? onObjectRemoved;

  void _update(Duration elapsed) {
    lastTick = DateTime.now();
    for (var e in gameObjects) {
      e.update(elapsed);
    }
    _checkCollisions();

    notifyListeners();
  }

  void startGame() {
    gameLoopStart = DateTime.now();
    lastTick = DateTime.now();
    _ticker.start();
  }

  void pause() {
    _ticker.muted = true;
  }

  void resume() {
    _ticker.muted = false;
    if (!_ticker.isActive) {
      startGame();
    }
  }

  void stopGame() {
    _ticker.stop();
  }

  @override
  void dispose() {
    super.dispose();
    _ticker.dispose();
  }

  get gameInProgress => _ticker.isTicking && !_ticker.muted;

  void _checkCollisions() {
    if (gameObjects.length < 2) return;

    var objects = gameObjects.toList();
    objects.removeWhere((e) => !e.collidable);

    var intersectionMap = <GameObject, List<Collision>>{};
    for (var e in objects) {
      intersectionMap[e] = [];
    }

    for (int i = 0; i < objects.length - 1; i++) {
      for (int j = i + 1; j < objects.length; j++) {
        var obj1 = objects[i];
        var obj2 = objects[j];
        var rect1 = Rect.fromPoints((obj1.position - (obj1.size / 2)).toOffset,
            (obj1.position + (obj1.size / 2)).toOffset);
        var rect2 = Rect.fromPoints((obj2.position - (obj2.size / 2)).toOffset,
            (obj2.position + (obj2.size / 2)).toOffset);
        if (rect1.overlaps(rect2)) {
          intersectionMap[obj1]!.add(Collision(rect1.intersect(rect2), obj2));
          intersectionMap[obj2]!.add(Collision(rect2.intersect(rect1), obj1));
        }
      }
    }

    intersectionMap.forEach((key, value) {
      if (value.isNotEmpty) {
        key.onCollision(value);
      }
    });
  }
}
