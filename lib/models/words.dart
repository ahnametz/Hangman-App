class Words {
  String randomWord = '';
  int incorrectGuessCount = 0;
  List<String> guessedLetters = [];

  Words({
    required this.randomWord,
    required this.incorrectGuessCount,
    required this.guessedLetters,
  });
  

  Map<String, dynamic> toMap() {
    return {
      'randomWord': randomWord,
      'incorrectGuessCount': incorrectGuessCount,
      'guessedLetters': guessedLetters, 
      
    };
    
  }
  
}



