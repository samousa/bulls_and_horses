enum Difficulty {
  easy,
  medium,
  hard,
}

class DifficultySettings {
  final int numberLength;
  final int maxAttempts;
  final String label;

  const DifficultySettings({
    required this.numberLength,
    required this.maxAttempts,
    required this.label,
  });

  static const Map<Difficulty, DifficultySettings> settings = {
    Difficulty.easy: DifficultySettings(
      numberLength: 3,
      maxAttempts: 10,
      label: 'Easy',
    ),
    Difficulty.medium: DifficultySettings(
      numberLength: 4,
      maxAttempts: 8,
      label: 'Medium',
    ),
    Difficulty.hard: DifficultySettings(
      numberLength: 5,
      maxAttempts: 6,
      label: 'Hard',
    ),
  };

  static DifficultySettings getSettings(Difficulty difficulty) {
    return settings[difficulty]!;
  }
}
