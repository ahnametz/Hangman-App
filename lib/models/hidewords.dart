class HideWords {
  static String hideWord(String word) {
    return List.filled(word.length, '_').join(' ');
  }
}
