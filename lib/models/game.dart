import 'dart:math';

class Game {
  final String secretNumber;
  final int length;
  final int maxAttempts;
  int attempts;
  bool isGameOver;
  bool isWon;
  List<Guess> guesses;

  Game({
    required this.secretNumber,
    required this.length,
    required this.maxAttempts,
    this.attempts = 0,
    this.isGameOver = false,
    this.isWon = false,
    List<Guess>? guesses,
  }) : guesses = guesses ?? [];

  // Generate a random secret number
  static String generateSecretNumber(int length) {
    final random = Random();
    final Set<int> digits = {};

    // Generate unique digits
    while (digits.length < length) {
      digits.add(random.nextInt(10));
    }

    return digits.join();
  }

  // Make a guess and return the result
  Guess makeGuess(String guess) {
    if (isGameOver) {
      throw Exception('Game is already over');
    }

    attempts++;

    // Calculate bulls (correct digit in correct position)
    int bulls = 0;
    for (int i = 0; i < length; i++) {
      if (guess[i] == secretNumber[i]) {
        bulls++;
      }
    }

    // Calculate horses (correct digit in wrong position)
    int horses = 0;
    for (int i = 0; i < length; i++) {
      if (secretNumber.contains(guess[i]) && guess[i] != secretNumber[i]) {
        horses++;
      }
    }

    // Create a new guess
    final newGuess = Guess(value: guess, bulls: bulls, horses: horses);

    guesses.add(newGuess);

    // Check if the game is over
    if (bulls == length) {
      isGameOver = true;
      isWon = true;
    } else if (attempts >= maxAttempts) {
      isGameOver = true;
    }

    return newGuess;
  }

  // Calculate score based on attempts and difficulty
  int calculateScore() {
    if (!isWon) return 0;

    // Base score depends on the difficulty (length of the number)
    int baseScore = length * 100;

    // Bonus for solving quickly
    double attemptBonus = ((maxAttempts - attempts + 1) / maxAttempts) * 100;

    return (baseScore + attemptBonus).round();
  }
}

class Guess {
  final String value;
  final int bulls;
  final int horses;

  Guess({required this.value, required this.bulls, required this.horses});
}
