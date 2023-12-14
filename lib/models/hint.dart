String getHintWord(String hiddenWord, String randomWord, int incorrectGuessCount) {
  if (hiddenWord.contains('_') && incorrectGuessCount < 6) {
    List<String> hiddenWordCharacters = hiddenWord.split(' ');

    for (int i = 0; i < hiddenWordCharacters.length; i++) {
      if (hiddenWordCharacters[i] == '_') {
        hiddenWordCharacters[i] = randomWord[i];
        break;
      }
    }

    return hiddenWordCharacters.join(' ');
  } else {
    return hiddenWord;
  }
}
