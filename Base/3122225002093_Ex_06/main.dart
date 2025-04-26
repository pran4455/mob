import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(GameApp());
}

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double playerX = 0;
  double playerY = 0.8;
  int score = 0;
  int lives = 3;
  bool isGameOver = false;
  List<Offset> obstacles = [];

  @override
  void initState() {
    super.initState();
    _startGameLoop();
  }

  void _startGameLoop() {
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (isGameOver) {
        timer.cancel();
        return;
      }
      setState(() {
        _moveObstacles();
        _checkCollisions();
      });
    });
  }

  void _movePlayer(double dx) {
    setState(() {
      playerX += dx;
      playerX = playerX.clamp(-1.0, 1.0);
    });
  }

  void _spawnObstacle() {
    setState(() {
      obstacles.add(Offset(Random().nextDouble() * 2 - 1, -1));
    });
  }

  void _moveObstacles() {
    for (int i = 0; i < obstacles.length; i++) {
      obstacles[i] = Offset(obstacles[i].dx, obstacles[i].dy + 0.02);
    }
    obstacles.removeWhere((obstacle) => obstacle.dy > 1);
    if (Random().nextDouble() < 0.02) {
      _spawnObstacle();
    }
  }

  void _checkCollisions() {
    for (var obstacle in obstacles) {
      if ((obstacle.dx - playerX).abs() < 0.1 && (obstacle.dy - playerY).abs() < 0.1) {
        setState(() {
          lives--;
          if (lives == 0) {
            isGameOver = true;
          }
        });
        break;
      }
    }
  }

  void _restartGame() {
    setState(() {
      playerX = 0;
      lives = 3;
      score = 0;
      obstacles.clear();
      isGameOver = false;
      _startGameLoop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          _movePlayer(details.primaryDelta! / 200);
        },
        onTap: () {
          setState(() {
            score += 10;
          });
        },
        child: Stack(
          children: [
            Container(color: Colors.blueGrey[900]),
            Positioned(
              top: MediaQuery.of(context).size.height * playerY,
              left: MediaQuery.of(context).size.width * (playerX + 1) / 2,
              child: Icon(Icons.directions_run, size: 50, color: Colors.white),
            ),
            ...obstacles.map((obstacle) => Positioned(
              top: MediaQuery.of(context).size.height * obstacle.dy,
              left: MediaQuery.of(context).size.width * (obstacle.dx + 1) / 2,
              child: Icon(Icons.circle, size: 30, color: Colors.red),
            )),
            Positioned(
              top: 40,
              left: 20,
              child: Text("Score: $score", style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: Text("Lives: $lives", style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            if (isGameOver)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Game Over", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    ElevatedButton(onPressed: _restartGame, child: Text("Restart"))
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
