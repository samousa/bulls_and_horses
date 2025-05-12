import 'package:flutter/material.dart';
import '../models/game.dart';
import '../utils/app_theme.dart';

class GuessHistory extends StatelessWidget {
  final List<Guess> guesses;

  const GuessHistory({Key? key, required this.guesses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (guesses.isEmpty) {
      return const Center(
        child: Text(
          'No guesses yet',
          style: TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      reverse: true,
      itemCount: guesses.length,
      itemBuilder: (context, index) {
        final guess = guesses[guesses.length - 1 - index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  child: Text(
                    '${guesses.length - index}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    guess.value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildResultIndicator(guess.bulls, AppTheme.bullColor, 'B'),
                const SizedBox(width: 10),
                _buildResultIndicator(guess.horses, AppTheme.horseColor, 'H'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultIndicator(int count, Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
