# Bulls and Horses Game

A fun and educational number guessing game built with Flutter and Dart, featuring SQLite for score tracking.

## Game Description

Bulls and Horses is a classic number guessing game where:

- The computer generates a secret number with unique digits
- Players try to guess the number
- After each guess, players receive feedback:
  - **Bulls**: Correct digit in the correct position
  - **Horses**: Correct digit in the wrong position
- Players win by guessing the number before running out of attempts

## Features

- Three difficulty levels (Easy, Medium, Hard)
- Score tracking with SQLite database
- Leaderboard with filtering by difficulty
- Child-friendly UI with intuitive controls
- Animated elements and visual feedback
- Offline play

## Screenshots

[Add screenshots here]

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Android Studio or VS Code with Flutter extensions
- Android or iOS device/emulator

### Installation

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/bulls_and_horses.git
   ```

2. Navigate to the project directory:
   ```
   cd bulls_and_horses
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```

## How to Play

1. Enter your name and select a difficulty level
2. Try to guess the secret number by entering digits
3. After each guess, you'll see:
   - Bulls (B): Number of correct digits in the correct position
   - Horses (H): Number of correct digits in the wrong position
4. Use these clues to refine your next guess
5. Try to guess the number before running out of attempts
6. Your score will be saved to the leaderboard if you win

## Project Structure

- `lib/models/`: Data models for the game and scores
- `lib/screens/`: UI screens (home, game, results, leaderboard)
- `lib/widgets/`: Reusable UI components
- `lib/database/`: SQLite database implementation
- `lib/utils/`: Utility classes and helpers

## Technologies Used

- Flutter
- Dart
- SQLite
- Animated Text Kit

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Inspired by the classic Bulls and Cows game
- Built for educational purposes to help children develop logical thinking skills
