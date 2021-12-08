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

  FlappyWidget flappyWidget = FlappyWidget();

  @override
  void initState() {
    super.initState();
    gameController.startGame();
    gameController.gameObjects.add(flappyWidget);
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
          GestureDetector(
            child: Illume(
              illumeController: gameController,
            ),
            onTap: () {
              print('tap');
              flappyWidget.jump();
            },
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

class FlappyWidget extends GameObject {
  var velocity = 0.0;
  var acceleration = 0.05;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: const Text('Demo'),
    );
  }

  @override
  void init() {
    size = Vector2.all(50);
    alignment = GameObjectAlignment.center;
    position = (gameSize / 2);
  }

  @override
  void onCollision(List<Collision> collisions) {
    illumeController.stopGame();
  }

  @override
  void onScreenSizeChange(Vector2 size) {}

  @override
  void update(Duration delta) {
    position += Vector2(0, velocity);
    velocity = velocity + acceleration;
  }

  void jump() {
    velocity = -10;
  }
}
