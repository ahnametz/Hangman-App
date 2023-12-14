import 'package:flutter_project_hangman/models/words.dart';
import 'package:path/path.dart' as pathPackage;
import 'package:sqflite/sqflite.dart' as sqflitePackage;

class SQFliteDbService {
  late sqflitePackage.Database db;
  late String path;

  Future<void> getOrCreateDatabaseHandle() async {
    try {
      var databasesPath = await sqflitePackage.getDatabasesPath();
      path = pathPackage.join(databasesPath, 'stocks_database.db');
      db = await sqflitePackage.openDatabase(
        path,
        onCreate: (sqflitePackage.Database db1, int version) async {
          await db1.execute(
            "CREATE TABLE game(randomword TEXT PRIMARY KEY, guessedLetters TEXT,  incorrectGuessCount INTEGER)",
          );
        },
        version: 1,
      );
      print('db = $db');
    } catch (e) {
      print('SQFliteDbService getOrCreateDatabaseHandle: $e');
    }
  }

  Future<void> loadGameInDbToConsole() async {
    try {
      List<Words> listOfWords = await loadGame();
      if (listOfWords.isEmpty) {
        print('No Stocks in the list');
      } else {
        for (var game in listOfWords) {
          print(
              'RandomWord{word: ${game.randomWord}, name: ${game.incorrectGuessCount}, price: ${game.guessedLetters}}');
        }
      }
    } catch (e) {
      print('SQFliteDbService loadGameInDbToConsole: $e');
    }
  }

  Future<List<Words>> loadGame() async {
    try {
      final List<Map<String, dynamic>> wordMap = await db.query('game');
      List<Words> games = List.generate(wordMap.length, (i) {
        print('Retrieving Game: $wordMap[i]'); // Add this line for debugging

        return Words(
          randomWord: wordMap[i]['randomword'],
          incorrectGuessCount: wordMap[i]['incorrectGuessCount'],
          guessedLetters: wordMap[i]['guessedLetters']
              .split(','), // Split stored string into a list
        );
      });
      return games;
    } catch (e) {
      print('SQFliteDbService loadGame: $e');
      return [];
    }
  }

  Future<void> deleteDb() async {
    try {
      await db.delete('game');
      print('All records deleted from the database.');
    } catch (e) {
      print('SQFliteDbService deleteAll: $e');
    }
  }

  Future<void> saveGame(Words game) async {
    try {
      await deleteDb(); // Delete the existing database before inserting a new game
      print('SQFliteDbService insertStock TRY');
      await db.insert(
        'game',
        {
          'randomWord': game.randomWord,
          'incorrectGuessCount': game.incorrectGuessCount,
          'guessedLetters':
              game.guessedLetters.join(','), // Convert list to a string
        },
        conflictAlgorithm: sqflitePackage.ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('SQFliteDbService saveGame: $e');
    }
  }

  Future<void> updateSavedGame(Words game) async {
    try {
      print('SQFliteDbService updateStock TRY');
      await db.update(
        'game',
        {
          'randomWord': game.randomWord,
          'incorrectGuessCount': game.incorrectGuessCount,
          'guessedLetters':
              game.guessedLetters.join(','), // Convert list to a string
        },
        where: "randomWord = ?",
        whereArgs: [game.randomWord],
      );
    } catch (e) {
      print('SQFliteDbService updateSavedGame: $e');
    }
  }
}
