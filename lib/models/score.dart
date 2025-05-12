class Score {
  int? id;
  String playerName;
  int score;
  int attempts;
  String difficulty;
  DateTime date;

  Score({
    this.id,
    required this.playerName,
    required this.score,
    required this.attempts,
    required this.difficulty,
    required this.date,
  });

  // Convert a Score object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'playerName': playerName,
      'score': score,
      'attempts': attempts,
      'difficulty': difficulty,
      'date': date.toIso8601String(),
    };
  }

  // Create a Score object from a Map
  factory Score.fromMap(Map<String, dynamic> map) {
    return Score(
      id: map['id'],
      playerName: map['playerName'],
      score: map['score'],
      attempts: map['attempts'],
      difficulty: map['difficulty'],
      date: DateTime.parse(map['date']),
    );
  }
}
