import 'package:flutter/material.dart';
import 'package:flutter_project_hangman/models/words.dart';
import 'package:flutter_project_hangman/services/database.dart';
import 'package:flutter_project_hangman/views/loadedgame.dart';

class LoadedNavigation {
  static Future<String?> loadSavedGame() async {
    final savedGames = await _getSavedGames();
    if (savedGames.isNotEmpty) {
      final loadedGame = savedGames.first;
      return loadedGame.randomWord;
    } else {
      return null;
    }
  }

  static Future<List<Words>> _getSavedGames() async {
    final dbService = SQFliteDbService();
    await dbService.getOrCreateDatabaseHandle();
    return await dbService.loadGame();
  }

  static void navigateToGame(BuildContext context, String word) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Loaded(
          getWordByLength: () => Future.value(word),
        ),
      ),
    );
  }
}
