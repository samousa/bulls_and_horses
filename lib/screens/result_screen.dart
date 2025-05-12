import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../utils/app_theme.dart';
import '../utils/difficulty.dart';
import 'game_screen.dart';
import 'home_screen.dart';
import 'leaderboard_screen.dart';

class ResultScreen extends StatelessWidget {
  final String playerName;
  final String secretNumber;
  final int attempts;
  final int maxAttempts;
  final int score;
  final bool isWon;
  final Difficulty difficulty;

  const ResultScreen({
    Key? key,
    required this.playerName,
    required this.secretNumber,
    required this.attempts,
    required this.maxAttempts,
    required this.score,
    required this.isWon,
    required this.difficulty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              isWon ? AppTheme.successColor : AppTheme.errorColor,
              AppTheme.backgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Result Title
                  AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        isWon ? 'You Won!' : 'Game Over',
                        textStyle: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                        colors: [
                          Colors.white,
                          isWon ? AppTheme.successColor : AppTheme.errorColor,
                          AppTheme.primaryColor,
                          Colors.white,
                        ],
                      ),
                    ],
                    isRepeatingAnimation: true,
                    repeatForever: true,
                  ),
                  const SizedBox(height: 30),

                  // Result Card
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Player Info
                          Text(
                            playerName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Difficulty: ${DifficultySettings.getSettings(difficulty).label}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const Divider(height: 30),

                          // Game Stats
                          _buildStatRow('Secret Number', secretNumber),
                          _buildStatRow(
                            'Attempts Used',
                            '$attempts / $maxAttempts',
                          ),
                          if (isWon) _buildStatRow('Score', score.toString()),
                          const SizedBox(height: 20),

                          // Result Message
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:
                                  isWon
                                      ? AppTheme.successColor.withAlpha(50)
                                      : AppTheme.errorColor.withAlpha(50),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              isWon
                                  ? 'Congratulations! You guessed the number in $attempts attempts!'
                                  : 'Better luck next time! The secret number was $secretNumber.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    isWon
                                        ? AppTheme.successColor
                                        : AppTheme.errorColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildActionButton(
                        context,
                        'Play Again',
                        Icons.replay,
                        AppTheme.accentColor,
                        () => _playAgain(context),
                      ),
                      const SizedBox(width: 15),
                      _buildActionButton(
                        context,
                        'Leaderboard',
                        Icons.leaderboard,
                        AppTheme.secondaryColor,
                        () => _viewLeaderboard(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildActionButton(
                    context,
                    'Home',
                    Icons.home,
                    AppTheme.primaryColor,
                    () => _goHome(context),
                    isFullWidth: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed, {
    bool isFullWidth = false,
  }) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Text(label, style: const TextStyle(fontSize: 16)),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  void _playAgain(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                GameScreen(playerName: playerName, difficulty: difficulty),
      ),
    );
  }

  void _viewLeaderboard(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LeaderboardScreen()),
    );
  }

  void _goHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }
}
