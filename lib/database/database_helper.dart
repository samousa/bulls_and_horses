import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Table name
  final String tableScores = 'scores';
  
  // Column names
  final String columnId = 'id';
  final String columnPlayerName = 'playerName';
  final String columnScore = 'score';
  final String columnAttempts = 'attempts';
  final String columnDifficulty = 'difficulty';
  final String columnDate = 'date';

  // Singleton constructor
  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    
    // Initialize the database if it doesn't exist
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'bulls_and_horses.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create the database tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableScores (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnPlayerName TEXT NOT NULL,
        $columnScore INTEGER NOT NULL,
        $columnAttempts INTEGER NOT NULL,
        $columnDifficulty TEXT NOT NULL,
        $columnDate TEXT NOT NULL
      )
    ''');
  }

  // Insert a score
  Future<int> insertScore(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(tableScores, row);
  }

  // Get all scores
  Future<List<Map<String, dynamic>>> getScores() async {
    Database db = await database;
    return await db.query(tableScores, orderBy: '$columnScore DESC');
  }

  // Get top scores
  Future<List<Map<String, dynamic>>> getTopScores(int limit) async {
    Database db = await database;
    return await db.query(
      tableScores,
      orderBy: '$columnScore DESC',
      limit: limit,
    );
  }

  // Get scores by difficulty
  Future<List<Map<String, dynamic>>> getScoresByDifficulty(String difficulty) async {
    Database db = await database;
    return await db.query(
      tableScores,
      where: '$columnDifficulty = ?',
      whereArgs: [difficulty],
      orderBy: '$columnScore DESC',
    );
  }

  // Delete a score
  Future<int> deleteScore(int id) async {
    Database db = await database;
    return await db.delete(
      tableScores,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Delete all scores
  Future<int> deleteAllScores() async {
    Database db = await database;
    return await db.delete(tableScores);
  }
}
