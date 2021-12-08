import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';
import 'package:illume/src/extensions.dart';

import 'collision.dart';

enum GameObjectAlignment {
  center,
  topLeft,
}

abstract class GameObject {
  Vector2 position = Vector2.zero();
  Vector2 size = Vector2.zero();
  Vector2 gameSize = Vector2.zero();
  bool visible = true;
  bool collidable = true;
  GameObjectAlignment alignment = GameObjectAlignment.center;
  bool initialised = false;

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
