import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  static const int boardSize = 15;
  static const Duration gameSpeed = Duration(milliseconds: 500);

  List<Point<int>> snake = [Point(7, 7)];
  Point<int> food = Point(5, 5);
  Direction direction = Direction.right;
  bool gameRunning = false;
  bool gameOver = false;
  int score = 0;
  Timer? gameTimer;

  @override
  void initState() {
    super.initState();
    _generateFood();
    // Auto-start the game after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _startGame();
      }
    });
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      snake = [Point(7, 7)];
      direction = Direction.right;
      score = 0;
      gameRunning = true;
      gameOver = false;
    });
    _generateFood();
    gameTimer = Timer.periodic(gameSpeed, (timer) {
      _moveSnake();
    });
  }

  void _pauseGame() {
    setState(() {
      gameRunning = false;
    });
    gameTimer?.cancel();
  }

  void _generateFood() {
    final random = Random();
    do {
      food = Point(random.nextInt(boardSize), random.nextInt(boardSize));
    } while (snake.contains(food));
  }

  void _moveSnake() {
    if (!gameRunning) return;

    final head = snake.first;
    Point<int> newHead;

    switch (direction) {
      case Direction.up:
        newHead = Point(head.x, head.y - 1);
        break;
      case Direction.down:
        newHead = Point(head.x, head.y + 1);
        break;
      case Direction.left:
        newHead = Point(head.x - 1, head.y);
        break;
      case Direction.right:
        newHead = Point(head.x + 1, head.y);
        break;
    }

    // Check wall collision
    if (newHead.x < 0 || newHead.x >= boardSize || 
        newHead.y < 0 || newHead.y >= boardSize) {
      _endGame();
      return;
    }

    // Check self collision
    if (snake.contains(newHead)) {
      _endGame();
      return;
    }

    setState(() {
      snake.insert(0, newHead);

      // Check food collision
      if (newHead == food) {
        score += 10;
        _generateFood();
      } else {
        snake.removeLast();
      }
    });
  }

  void _endGame() {
    setState(() {
      gameRunning = false;
      gameOver = true;
    });
    gameTimer?.cancel();
  }

  void _changeDirection(Direction newDirection) {
    // Prevent reverse direction
    if ((direction == Direction.up && newDirection == Direction.down) ||
        (direction == Direction.down && newDirection == Direction.up) ||
        (direction == Direction.left && newDirection == Direction.right) ||
        (direction == Direction.right && newDirection == Direction.left)) {
      return;
    }
    direction = newDirection;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Snake Game'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(gameRunning ? Icons.pause : Icons.play_arrow),
            onPressed: gameRunning ? _pauseGame : _startGame,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Score: $score',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                if (!gameRunning && !gameOver)
                  const Text(
                    'Tap ▶️ to start or use arrow buttons to control',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: boardSize,
                  ),
                  itemCount: boardSize * boardSize,
                  itemBuilder: (context, index) {
                    final x = index % boardSize;
                    final y = index ~/ boardSize;
                    final point = Point(x, y);

                    Color cellColor = Colors.black;
                    if (snake.contains(point)) {
                      cellColor = snake.first == point ? Colors.green : Colors.lightGreen;
                    } else if (point == food) {
                      cellColor = Colors.red;
                    }

                    return Container(
                      margin: const EdgeInsets.all(0.3),
                      decoration: BoxDecoration(
                        color: cellColor,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          if (gameOver)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text(
                    'Game Over!',
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  ElevatedButton(
                    onPressed: _startGame,
                    child: const Text('Play Again'),
                  ),
                ],
              ),
            ),
          // Control buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (!gameRunning && !gameOver) _startGame();
                        _changeDirection(Direction.up);
                      },
                      icon: const Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 32),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (!gameRunning && !gameOver) _startGame();
                        _changeDirection(Direction.left);
                      },
                      icon: const Icon(Icons.keyboard_arrow_left, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 32),
                    IconButton(
                      onPressed: () {
                        if (!gameRunning && !gameOver) _startGame();
                        _changeDirection(Direction.right);
                      },
                      icon: const Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 32),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (!gameRunning && !gameOver) _startGame();
                        _changeDirection(Direction.down);
                      },
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum Direction { up, down, left, right }
