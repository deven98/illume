import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';
import 'package:illume/src/extensions.dart';

import '../illume_controller.dart';
import 'collision.dart';

/// Defines the alignment of the [GameObject]
/// If set to [GameObjectAlignment.topLeft], the position of the object is calculated wrt to the top left corner
/// If set to [GameObjectAlignment.center], the position of the object is calculated wrt to the center
enum GameObjectAlignment {
  center,
  topLeft,
}

/// Class defining a game object for Illume
abstract class GameObject {
  Vector2 position = Vector2.zero();
  Vector2 size = Vector2.zero();
  Vector2 gameSize = Vector2.zero();
  bool visible = true;
  bool collidable = true;
  GameObjectAlignment alignment = GameObjectAlignment.center;
  bool initialised = false;
  late IllumeController illumeController;

  void init();

  Widget build(BuildContext context);

  void update(Duration delta);

  void onScreenSizeChange(Vector2 size);

  void onCollision(List<Collision> collisions);

  Rect getPositionRect() {
    switch (alignment) {
      case GameObjectAlignment.center:
        return Rect.fromPoints(position.toOffset - (size.toOffset / 2.0),
            position.toOffset + (size.toOffset / 2.0));
      case GameObjectAlignment.topLeft:
        return Rect.fromPoints(
            position.toOffset, position.toOffset + size.toOffset);
    }
  }
}
