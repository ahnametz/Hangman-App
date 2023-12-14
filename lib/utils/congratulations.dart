import 'package:flutter/material.dart';
import 'package:flutter_project_hangman/views/root.dart';

void displayCongratulationsPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Congratulations!'),
        content: const Text('You guessed the word correctly!'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); 
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => DifficultyScreen(), 
                ),
              );
            },
            child: const Text('Start New Game'),
          ),
        ],
      );
    },
  );
}
