import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/game.dart';
import '../models/score.dart';
import '../utils/app_theme.dart';
import '../utils/difficulty.dart';
import '../widgets/guess_history.dart';
import '../widgets/number_input.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  final String playerName;
  final Difficulty difficulty;

  const GameScreen({
    Key? key,
    required this.playerName,
    required this.difficulty,
  }) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Game _game;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    final settings = DifficultySettings.getSettings(widget.difficulty);
    final secretNumber = Game.generateSecretNumber(settings.numberLength);

    _game = Game(
      secretNumber: secretNumber,
      length: settings.numberLength,
      maxAttempts: settings.maxAttempts,
    );

    // Secret number is generated and ready
  }

  void _makeGuess(String guess) {
    if (_game.isGameOver) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate a delay for better UX
    Future.delayed(const Duration(milliseconds: 300), () {
      try {
        final result = _game.makeGuess(guess);

        setState(() {
          _isLoading = false;
        });

        // Check if the game is over (win or out of attempts)
        if (_game.isGameOver) {
          if (!_game.isWon && mounted) {
            // Show a message that the player ran out of attempts
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Game over! The secret number was ${_game.secretNumber}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: AppTheme.errorColor,
                duration: const Duration(seconds: 3),
              ),
            );
          }

          // Navigate to result screen after a short delay
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              _saveScore();
            }
          });
        } else {
          // Show feedback for the guess if the game is not over
          if (mounted) {
            _showGuessFeedback(result);
          }
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    });
  }

  void _showGuessFeedback(Guess guess) {
    String message;
    Color backgroundColor;

    if (guess.bulls == _game.length) {
      message = 'Congratulations! You guessed the number!';
      backgroundColor = AppTheme.successColor;
    } else if (guess.bulls > 0 || guess.horses > 0) {
      message = 'Good try! ${guess.bulls} Bulls, ${guess.horses} Horses';
      backgroundColor = AppTheme.warningColor;
    } else {
      message = 'No matches. Try again!';
      backgroundColor = AppTheme.errorColor;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _saveScore() async {
    // Save score only if the player won
    if (_game.isWon) {
      final score = Score(
        playerName: widget.playerName,
        score: _game.calculateScore(),
        attempts: _game.attempts,
        difficulty: DifficultySettings.getSettings(widget.difficulty).label,
        date: DateTime.now(),
      );

      await _databaseHelper.insertScore(score.toMap());
    }

    // Navigate to the result screen for both win and loss
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => ResultScreen(
                playerName: widget.playerName,
                secretNumber: _game.secretNumber,
                attempts: _game.attempts,
                maxAttempts: _game.maxAttempts,
                score: _game.calculateScore(),
                isWon: _game.isWon,
                difficulty: widget.difficulty,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = DifficultySettings.getSettings(widget.difficulty);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bulls & Horses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showGameRules,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // Game Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: AppTheme.primaryColor.withAlpha(25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoCard(
                          'Player',
                          widget.playerName,
                          Icons.person,
                        ),
                        _buildInfoCard(
                          'Difficulty',
                          settings.label,
                          Icons.speed,
                        ),
                        _buildInfoCard(
                          'Attempts',
                          '${_game.attempts}/${_game.maxAttempts}',
                          Icons.refresh,
                        ),
                      ],
                    ),
                  ),

                  // Number Input
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: NumberInput(
                      length: settings.numberLength,
                      onSubmit: _makeGuess,
                      enabled: !_game.isGameOver,
                    ),
                  ),

                  // Guess History
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 16, bottom: 8),
                            child: Text(
                              'Guess History:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(child: GuessHistory(guesses: _game.guesses)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryColor),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showGameRules() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Game Rules'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Bulls & Horses is a number guessing game:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '• I\'ve selected a secret number with unique digits',
                  ),
                  const Text('• You need to guess this number'),
                  const Text('• After each guess, you\'ll get clues:'),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      '- Bulls (B): Correct digit in correct position',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      '- Horses (H): Correct digit in wrong position',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '• You have ${_game.maxAttempts} attempts to guess the number',
                  ),
                  Text('• The secret number has ${_game.length} digits'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Got it!'),
              ),
            ],
          ),
    );
  }
}
