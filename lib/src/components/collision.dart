import 'package:flutter/material.dart';

import 'game_object.dart';

/// Holds information about collision between two objects
class Collision {
  final Rect intersectionRect;
  final GameObject component;

  Collision(this.intersectionRect, this.component);
}
