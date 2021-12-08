# illume 

## A Widget-based Game Engine for Flutter 

Illume is a simple Flutter game engine which uses widgets to create game objects instead of sprites 
in normal game engines. This allows the app and game part to be quite integrated and use a lot of 
common components without needing graphics work to create sprites and backgrounds (which was honestly 
my main motivation, since I don't know anything about graphics design). It's also quite easy to create 
and manage the game state as shown in the features ahead. A lot of functionality still be be implemented 
including physics - only normal box-based collision is currently implemented.

Some parts were inspired by other game engines, primarily [Flame](https://github.com/flame-engine/flame).

DISCLAIMER: Since widgets are heavier than sprites drawn on a canvas, this engine is going to be 
less performant than others. It is in a very early stage and I plan to add a lot of features but 
this is primarily due to my interest in having widget-based game engines -- any serious game 
development should still be carried out with more mature engines like [Flame](https://github.com/flame-engine/flame).
This is just meant as an experiment to satisfy my curiosity. I quite like - and still heavily use the 
main Flutter game engines whose development teams I respect a lot. 

## Features

### Use Widgets directly to build your game objects

```dart
class FlappyWidget extends GameObject {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: const Text('Demo'),
    );
  }

  @override
  void init() {}

  @override
  void onCollision(List<Collision> collisions) { }

  @override
  void onScreenSizeChange(Vector2 size) {}

  @override
  void update(Duration delta) {}

  //...
}
```

### Easy game development without large separation between widgets and games 

You can add a game to your app simply by adding an `Illume` widget and an `IllumeController`. (More 
info given in usage section)

```dart
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
      body: Illume(
        illumeController: gameController,
      ),
    );
  }
}

// Definition of game object given later
```

### `IllumeController` allows easy manipulation of game state

```dart
  IllumeController gameController = IllumeController();

  gameController.startGame();
  gameController.gameObjects.add(DemoObject());
  gameController.stopGame();
  // etc
```

The controller is also available for use in all game objects so no need for an abundance of callbacks.

### Collision detection

Collision detection is enabled by default for all objects which can be turned off. Every object is 
notified of collisions as well as given the `Rect` of intersection so collisions can be better 
understood. This is a very early prototype so no complex physics (Box2d-ish) exist but I hope to 
add this in the future.

```dart
class FlappyWidget extends GameObject {

  //...
  
  @override
  void onCollision(List<Collision> collisions) { 
    // This gives a list of objects which are colliding with this one 
    // as well as the rect of intersection.
  }

  //...
}
```

### Gesture Detection

This is technically NOT a feature of illume since we can use the default Flutter gesture detecting 
widgets like the `GestureDetector` to power our apps. Check the example provided in the repo for more 
but here is a short demo: 

```dart
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
        body: Illume(
          illumeController: gameController,
        ),
      ),
    );
  }
```

## Usage

### Step 1

Add the dependency first: 

```yaml
dependencies:
  illume: ^0.1.0
```

### Step 2

Add the `Illume` widget and associated `IllumeController` wherever you need to create a game:

```dart
IllumeController gameController = IllumeController();

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Illume Demo'),
      ),
      body: Illume(
        illumeController: gameController,
      ),
    );
  }
```

### Step 3

Define your `GameObject` by extending the class:

```dart
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
  void onScreenSizeChange(Vector2 size) {
    // This is a quick demo but you really should shift your positions in a
    // real world app or at least lock orientation.
  }

  @override
  void update(Duration delta) {
    position += Vector2(0, velocity);
    velocity = velocity + acceleration;
  }

  void jump() {
    velocity = -5;
  }
}
```

### Note: In the object there are various properties - 

* `gameSize` gives the max size for the game. 
* `alignment` allows you to align the center to the center of the widget or the top left corner of 
the widget.
* `position` is the position of the widget.
* `size` is the size of the widget.
* `illumeController` is the game controller for the game. 

### Step 4

Add the object to the game and start the game:

```dart
  FlappyWidget flappyWidget = FlappyWidget();

  @override
  void initState() {
    super.initState();
    gameController.startGame();
    gameController.gameObjects.add(flappyWidget);
  }
```

Check out the full example for the demo flappy bird game (This is a very basic demo for now, I'll 
add a far better one later).