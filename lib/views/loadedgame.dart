import 'package:flutter/material.dart';
import 'package:flutter_project_hangman/models/hidewords.dart';
import 'package:flutter_project_hangman/models/words.dart';
import 'package:flutter_project_hangman/services/database.dart';
import 'package:flutter_project_hangman/utils/congratulations.dart';
import 'package:flutter_project_hangman/utils/gameover.dart';
import 'package:flutter_project_hangman/utils/hangman.dart';
import 'package:flutter_project_hangman/models/hint.dart';

class Loaded extends StatefulWidget {
  final Future<String> Function() getWordByLength;

  const Loaded({required this.getWordByLength});

  @override
  _LoadedState createState() => _LoadedState();
}

class _LoadedState extends State<Loaded> {
  String _randomWord = 'Loading...';
  String _hiddenWord = '';
  int _incorrectGuessCount = 0;
  int maxIncorrectCount = 6;
  final TextEditingController _guessController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadRandomWord();
    _loadSavedData();
  }

  void _saveGame() async {
    Words currentGame = Words(
      randomWord: _randomWord,
      incorrectGuessCount: _incorrectGuessCount,
      guessedLetters: _guessedLettersSet.toList(),
    );

    SQFliteDbService dbService = SQFliteDbService();
    await dbService.getOrCreateDatabaseHandle();

    try {
      await dbService.saveGame(currentGame);
      print('Game saved successfully.');
    } catch (e) {
      print('Error saving game: $e');
    }
  }

  void _resetGame() async {
    SQFliteDbService dbService = SQFliteDbService();
    await dbService.deleteDb(); // Clear the entire database

    setState(() {
      _incorrectGuessCount = 0;
      _loadRandomWord();
      _guessController.clear();
      _guessedLettersSet.clear(); // Clear guessed letters
      _clearGuessedLetters();
      // Clear displayed guessed letters
    });
  }

  void _loadSavedData() async {
    SQFliteDbService dbService = SQFliteDbService();
    await dbService.getOrCreateDatabaseHandle();

    List<Words> savedGames = await dbService.loadGame();
    if (savedGames.isNotEmpty) {
      Words loadedGame = savedGames.first;

      setState(() {
        // Combine loaded guessed letters with the current guessed letters set
        _guessedLettersSet.addAll(loadedGame.guessedLetters);

        for (String letter in _guessedLettersSet) {
          _updateHiddenWord(letter);
        }
      });

      print(
          'Loaded Game: ${loadedGame.randomWord}, ${loadedGame.incorrectGuessCount}, ${loadedGame.guessedLetters}');
      _clearGuessedLetters();
    } else {
      print('No saved game found');
    }
  }

  void _loadRandomWord() async {
    setState(() {
      _loading = true;
    });

    try {
      String word = await widget.getWordByLength();
      setState(() {
        _randomWord = word;
        _incorrectGuessCount = 0;
        _hiddenWord = HideWords.hideWord(word);
        _loading = false;
      });
    } catch (error) {
      print('Error loading random word: $error');
      setState(() {
        _loading = false;
      });
    }
  }

  final Set<String> _guessedLettersSet = {};

  void _makeGuess() {
    String guess = _guessController.text;
    int wordLength = _randomWord.length;
    if (wordLength == 5 && guess.length > 5) {
      _showErrorMessage('Maximum 5 characters allowed for Easy level');
      return;
    } else if (wordLength == 7 && guess.length > 7) {
      _showErrorMessage('Maximum 7 characters allowed for Medium level');
      return;
    } else if (wordLength == 10 && guess.length > 10) {
      _showErrorMessage('Maximum 10 characters allowed for Hard level');
      return;
    }
    bool correctGuess = false;

    for (int i = 0; i < guess.length; i++) {
      String letter = guess[i];
      if (_randomWord.contains(letter)) {
        // Update _hiddenWord with the correct guess in its respective position
        _updateHiddenWord(letter);
        correctGuess = true;

        // Save the correct guess directly
        if (!_guessedLettersSet.contains(letter)) {
          _guessedLettersSet.add(
              letter); // Add the guessed letter to the set if not already present
        }
      }
    }

    if (!correctGuess) {
      setState(() {
        _incorrectGuessCount++;
      });
    }

    // Check if the entire word has been guessed correctly
    if (_hiddenWord.replaceAll(' ', '') == _randomWord) {
      _displayCongratulationsPopup();
      return;
    }

    _gameOver();
    _guessController.clear();
  }

  void _displayCongratulationsPopup() {
    displayCongratulationsPopup(context);
  }

  void _gameOver() {
    showGameOverDialog(
        context, _resetGame, maxIncorrectCount, _incorrectGuessCount);
  }

  void _hintWord() {
    String updatedHiddenWord =
        getHintWord(_hiddenWord, _randomWord, _incorrectGuessCount);

    setState(() {
      _hiddenWord = updatedHiddenWord;
    });
  }

  void _updateHiddenWord(String guess) {
    List<String> updatedHiddenWord = _hiddenWord.split(' ');
    List<String> actualWordCharacters = _randomWord.split('');

    for (int i = 0; i < actualWordCharacters.length; i++) {
      if (actualWordCharacters[i] == guess) {
        updatedHiddenWord[i] = guess;
      }
    }

    setState(() {
      _hiddenWord = updatedHiddenWord.join(' ');
    });
  }

  void _clearGuessedLetters() {
    setState(() {
      _guessedLettersSet.clear();
    });
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hangman App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HangmanImage(
              incorrectGuessCount: _incorrectGuessCount,
              maxIncorrectCount: maxIncorrectCount,
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: _loading,
              child: const CircularProgressIndicator(),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15),
              child: Text(
                'Hidden Word:',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _hiddenWord,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Incorrect Guesses: $_incorrectGuessCount',
              style: const TextStyle(fontSize: 18),
            ),
          
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _guessController,
                maxLength: _randomWord.length,
                decoration: const InputDecoration(
                  labelText: 'Enter Guess',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _loadRandomWord,
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: _makeGuess,
                  child: const Text('Make Guess'),
                ),
                ElevatedButton(
                  onPressed: _hintWord,
                  child: const Text('Hint'),
                ),
                ElevatedButton(
                  onPressed: _saveGame,
                  child: const Text('Save Game'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
