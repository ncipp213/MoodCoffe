import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'moodcoffee.db');
    return await openDatabase(
      path,
      version: 2, // Update version karena struktur tabel berubah
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Optional, untuk migrasi jika sudah ada database lama
    );
  }

  // Fungsi untuk membuat tabel dari awal (saat database pertama kali dibuat)
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phone TEXT NOT NULL,
        address TEXT NOT NULL,
        photoPath TEXT,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE coffees (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        price TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        rating REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE cart_items (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        milk TEXT NOT NULL,
        size TEXT NOT NULL,
        price INTEGER NOT NULL,
        quantity INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        coffeeId TEXT NOT NULL,
        FOREIGN KEY (coffeeId) REFERENCES coffees (id) ON DELETE CASCADE
      )
    ''');
  }

  // Fungsi upgrade untuk menambahkan kolom password jika database sudah ada (versi 1 -> 2)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE users ADD COLUMN password TEXT NOT NULL DEFAULT ""');
    }
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}