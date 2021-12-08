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

/// Quick demo for vertical screens
class _MyHomePageState extends State<MyHomePage> {
  IllumeController gameController = IllumeController();

  FlappyWidget flappyWidget = FlappyWidget();
  Wall wall = Wall(200, false);
  Wall wall2 = Wall(400, true);

  @override
  void initState() {
    super.initState();
    gameController.startGame();
    gameController.gameObjects.addAll([flappyWidget, wall, wall2]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        flappyWidget.jump();
      },
      child: Scaffold(
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
  var acceleration = 0.2;

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
    velocity = -5;
  }
}

class Wall extends GameObject {
  int initialDistance;
  bool vert;

  Wall(
    this.initialDistance,
    this.vert,
  );

  var velocity = -2.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: const Text('Demo'),
    );
  }

  @override
  void init() {
    size = Vector2(50, gameSize[1] / 2);
    alignment = GameObjectAlignment.center;
    position = Vector2(
      (gameSize[0] / 2) + initialDistance,
      (vert ? 1 : 3) * gameSize[1] / 4,
    );
  }

  @override
  void onCollision(List<Collision> collisions) {
    illumeController.stopGame();
  }

  @override
  void onScreenSizeChange(Vector2 size) {}

  @override
  void update(Duration delta) {
    position += Vector2(velocity, 0);
    if (position[0] < -50) {
      position[0] = gameSize[0] + 25;
    }
  }
}
