import 'package:flutter/material.dart';
import 'package:illume/illume.dart';
import 'package:illume/src/components/game_object.dart';
import 'package:illume/src/illume_controller.dart';
import 'package:illume/src/extensions.dart';

class Illume extends StatefulWidget {
  final IllumeController illumeController;

  const Illume({
    Key? key,
    required this.illumeController,
  }) : super(key: key);

  @override
  _IllumeState createState() => _IllumeState();
}

class _IllumeState extends State<Illume> {
  Offset lastSize = const Offset(0, 0);
  Map<GameObject, Widget> widgetCache = {};

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<GameObject>>(
      valueListenable: widget.illumeController,
      builder: (context, value, child) {
        var objects = getVisibleGameObjects();

        return LayoutBuilder(builder: (context, constraints) {
          var newSize = Offset(constraints.maxWidth, constraints.maxHeight);
          if (newSize != lastSize) {
            _changeSize(newSize);
            lastSize = newSize;
          }

          return Stack(
            children: objects.map(
              (e) {
                var position = e.getPositionRect();
                return Positioned(
                  top: position.topLeft.dy,
                  left: position.topLeft.dx,
                  child: SizedBox(
                    width: e.size[0],
                    height: e.size[1],
                    child: getObjectWidget(e),
                  ),
                );
              },
            ).toList(),
          );
        });
      },
    );
  }

  Widget getObjectWidget(GameObject e) {
    if (widgetCache[e] != null) {
      return widgetCache[e]!;
    }

    var newWidget = e.build(context);
    widgetCache[e] = newWidget;

    if (widgetCache.length != widget.illumeController.gameObjects.length) {
      var removeList = widgetCache.keys
          .where((e) => !widget.illumeController.gameObjects.contains(e))
          .toList();
      removeList.forEach(widgetCache.remove);
    }

    return newWidget;
  }

  List<GameObject> getVisibleGameObjects() {
    var objects = widget.illumeController.gameObjects;
    objects.removeWhere((e) => !e.visible);
    return objects;
  }

  void _changeSize(Offset size) {
    for (var e in widget.illumeController.gameObjects) {
      e.gameSize = Vector2(size.dx, size.dy);
      if (!e.initialised) {
        e.illumeController = widget.illumeController;
        e.init();
        e.initialised = true;
      }
      e.onScreenSizeChange(size.toVector2);
    }
  }
}
