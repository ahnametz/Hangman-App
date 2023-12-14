import 'package:flutter/material.dart';
import 'package:flutter_project_hangman/views/Game.dart';
import 'package:flutter_project_hangman/services/word-generator.dart';

class GameNavigation {
  static void startGame(BuildContext context, int wordLength) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeView(
          getWordByLength: () {
            return _getRandomWord(wordLength);
          },
        ),
      ),
    );
  }

  static Future<String> _getRandomWord(int wordLength) async {
    WordService wordService = WordService();
    try {
      return await wordService.getWordByLength(wordLength);
    } catch (error) {
      print('Error loading random word: $error');
      return 'Error';
    }
  }
}
