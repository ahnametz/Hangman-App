import 'package:flutter/material.dart';

void showGameOverDialog(BuildContext context, Function resetGame,
    int maxIncorrectCount, int incorrectGuessCount) {
  if (incorrectGuessCount >= maxIncorrectCount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content:
              const Text('You reached the maximum allowed incorrect guesses.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: const Text('Restart Game'),
            ),
          ],
        );
      },
    );
  }
}
