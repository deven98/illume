import 'dart:ui';

import 'package:vector_math/vector_math.dart';

/// Converts [Vector2] to [Offset]
extension Vector2ToOffset on Vector2 {
  get toOffset => Offset(this[0], this[1]);
}

/// Converts [Size] to [Vector2]
extension SizeToVector2 on Size {
  get toOffset => Offset(width, height);
  get toVector2 => Vector2(width, height);
}

/// Converts [Offset] to [Vector2]
extension OffsetToVector2 on Offset {
  get toVector2 => Vector2(dx, dy);
}
