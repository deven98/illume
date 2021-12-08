import 'dart:math';

import 'package:flutter/material.dart';
import 'package:illume/illume.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  IllumeController gameController = IllumeController();

  @override
  void initState() {
    super.initState();
    gameController.startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Illume Demo'),
      ),
      body: Stack(
        children: [
          gradient,
          Illume(
            illumeController: gameController,
          ),
        ],
      ),
    );
  }

  var gradient = Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
          colors: [Colors.teal, Colors.deepPurple],
          stops: [0.0, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight),
    ),
  );
}

class DemoObject extends GameObject {
  int dx;

  DemoObject(this.dx);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Color?>(
      duration: Duration(seconds: 1),
      tween: ColorTween(begin: Colors.red, end: Colors.blue),
      builder: (context, color, wid) {
        return Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: SizedBox.expand(),
        );
      },
    );
  }

  @override
  void init() {
    size = Vector2.all(50);
    alignment = GameObjectAlignment.center;
    position = (gameSize / 2) + Vector2(dx.toDouble(), 0);
  }

  @override
  void onCollision(List<Collision> collisions) {
    // TODO: implement onCollision
  }

  @override
  void onScreenSizeChange(Vector2 size) {}

  @override
  void update(Duration delta) {
    position[1]--;
    if (position[1] < 0) {
      position[1] = 500;
    }
  }
}
