import 'dart:ui';

import 'package:vector_math/vector_math.dart';

extension Vector2ToOffset on Vector2 {
  get toOffset => Offset(this[0], this[1]);
}

extension SizeToVector2 on Size {
  get toOffset => Offset(width, height);
  get toVector2 => Vector2(width, height);
}

extension OffsetToVector2 on Offset {
  get toVector2 => Vector2(dx, dy);
}
