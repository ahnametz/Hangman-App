import 'package:flutter/material.dart';
import 'package:flutter_project_hangman/services/loaded_navigation.dart';
import 'package:flutter_project_hangman/services/game_navigation.dart';

class DifficultyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Difficulty / Load Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select Word Length:',
              style:
                  TextStyle(fontSize: 30), 
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => GameNavigation.startGame(context, 5),
                  child: const Text('Easy (5)'),
                ),
                ElevatedButton(
                  onPressed: () => GameNavigation.startGame(context, 7),
                  child: const Text('Medium (7)'),
                ),
                ElevatedButton(
                  onPressed: () => GameNavigation.startGame(context, 10),
                  child: const Text('Hard (10)'),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                LoadedNavigation.loadSavedGame().then((word) {
                  if (word != null) {
                    LoadedNavigation.navigateToGame(context, word);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No saved games available'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                });
              },
              child: const Text('Load Saved Game'),
            ),
          ],
        ),
      ),
    );
  }
}
