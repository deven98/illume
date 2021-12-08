import 'package:flutter/material.dart';

import 'game_object.dart';

class Collision {
  final Rect intersectionRect;
  final GameObject component;

  Collision(this.intersectionRect, this.component);
}
