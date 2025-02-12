import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame {
  late Player player;
  late Enemy enemy;
  ValueNotifier<int> score = ValueNotifier<int>(0);
  ValueNotifier<double> timeSurvived = ValueNotifier<double>(0);
  bool isGameOver = false;
  BuildContext? context;

  @override
  Future<void> onLoad() async {
    player = Player();
    enemy = Enemy();
    add(player);
    add(enemy);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isGameOver) {
      timeSurvived.value += dt;

      // Ajustamos la lógica de colisión para verificar si al menos el 50% de una imagen
      // está dentro de la otra (calculando la intersección)
      Rect playerRect = player.toRect();
      Rect enemyRect = enemy.toRect();

      // Calculamos la intersección de los rectángulos
      Rect intersection = playerRect.intersect(enemyRect);

      // Si las imágenes se solapan al menos el 50% en el eje Y (vertical), se termina el juego
      if (intersection.height >= playerRect.height * 0.5 &&
          intersection.width > 0) {
        // Aseguramos que haya colisión horizontal también
        isGameOver = true;
        showGameOverDialog();
      }
    }
  }

  void showGameOverDialog() {
    if (context != null) {
      showDialog(
        context: context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Game Over"),
            content: Text(
                "Score: ${score.value}\nTime: ${timeSurvived.value.toStringAsFixed(1)}s"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  resetGame();
                },
                child: const Text("Retry"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text("Exit"),
              ),
            ],
          );
        },
      );
    }
  }

  void resetGame() {
    isGameOver = false;
    score.value = 0;
    timeSurvived.value = 0;
    player.position = Vector2(size.x / 2, size.y - 180);
    enemy.position =
        Vector2(Random().nextDouble() * (size.x - enemy.size.x), 0);
  }
}

class Player extends SpriteComponent with HasGameRef<MyGame> {
  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('player.png');
    size = Vector2(150, 150); // Tamaño del jugador
    position = Vector2(gameRef.size.x / 2, gameRef.size.y - 180);
  }

  void moveLeft() {
    if (!gameRef.isGameOver) {
      position.x = max(0, position.x - 10);
    }
  }

  void moveRight() {
    if (!gameRef.isGameOver) {
      position.x = min(gameRef.size.x - size.x, position.x + 10);
    }
  }
}

class Enemy extends SpriteComponent with HasGameRef<MyGame> {
  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('enemy.png');
    size = Vector2(80, 80); // Aumentamos el tamaño del enemigo
    position = Vector2(Random().nextDouble() * (gameRef.size.x - size.x), 0);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!gameRef.isGameOver) {
      position.y += 2;
      if (position.y > gameRef.size.y) {
        position.y = 0;
        position.x = Random().nextDouble() * (gameRef.size.x - size.x);
        gameRef.score.value += 1;
      }
    }
  }
}

class Gametest extends StatelessWidget {
  const Gametest({super.key});

  @override
  Widget build(BuildContext context) {
    final MyGame game = MyGame();
    game.context = context;

    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: game),
          Positioned(
            top: 40,
            left: 20,
            child: Column(
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: game.score,
                  builder: (context, score, _) => Text(
                    'Score: $score',
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                ValueListenableBuilder<double>(
                  valueListenable: game.timeSurvived,
                  builder: (context, time, _) => Text(
                    'Time: ${time.toStringAsFixed(1)}s',
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: GestureDetector(
              onTap: () => game.player.moveLeft(),
              child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Container(color: Colors.transparent)),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () => game.player.moveRight(),
              child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Container(color: Colors.transparent)),
            ),
          ),
        ],
      ),
    );
  }
}
