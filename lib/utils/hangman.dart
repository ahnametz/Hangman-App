import 'package:flutter/material.dart';

class HangmanImage extends StatelessWidget {
  final int incorrectGuessCount;
  final int maxIncorrectCount;

  const HangmanImage({
    required this.incorrectGuessCount,
    required this.maxIncorrectCount,
  });

  @override
  Widget build(BuildContext context) {
    int adjustedIncorrectCount = incorrectGuessCount > maxIncorrectCount
        ? maxIncorrectCount
        : incorrectGuessCount;

    String imagePath = 'assets/images/$adjustedIncorrectCount.png';

    return Image.asset(
      imagePath,
      width: 100,
      height: 100,
      color: Colors.black,
    );
  }
}
