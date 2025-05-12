import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class GameInstructions extends StatelessWidget {
  const GameInstructions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(50),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How to Play',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          _buildInstructionItem(
            '1',
            'I\'ll think of a secret number with unique digits',
          ),
          _buildInstructionItem('2', 'You need to guess the number'),
          _buildInstructionItem('3', 'After each guess, I\'ll give you clues:'),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildClueItem(
                  AppTheme.bullColor,
                  'B',
                  'Bulls: Correct digit in the correct position',
                ),
                const SizedBox(height: 5),
                _buildClueItem(
                  AppTheme.horseColor,
                  'H',
                  'Horses: Correct digit in the wrong position',
                ),
              ],
            ),
          ),
          _buildInstructionItem(
            '4',
            'Use these clues to guess the number before running out of attempts!',
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppTheme.primaryColor,
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildClueItem(Color color, String label, String explanation) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(explanation, style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }
}
