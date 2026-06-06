import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/coffee.dart';

class FavoriteProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Coffee> _favorites = [];

  List<Coffee> get favorites => _favorites;

  Future<void> loadFavorites() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> favMaps = await db.query('favorites');
    final List<String> favIds = favMaps.map((map) => map['coffeeId'] as String).toList();

    if (favIds.isEmpty) {
      _favorites = [];
      notifyListeners();
      return;
    }

    final String placeholders = favIds.map((_) => '?').join(',');
    final List<Map<String, dynamic>> coffeeMaps = await db.query(
      'coffees',
      where: 'id IN ($placeholders)',
      whereArgs: favIds,
    );
    _favorites = coffeeMaps.map((map) => Coffee.fromMap(map)).toList();
    notifyListeners();
  }

  Future<bool> isFavorite(String coffeeId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query(
      'favorites',
      where: 'coffeeId = ?',
      whereArgs: [coffeeId],
    );
    return result.isNotEmpty;
  }

  Future<void> toggleFavorite(Coffee coffee) async {
    final exists = await isFavorite(coffee.id);
    if (exists) {
      await removeFavorite(coffee.id);
    } else {
      await addFavorite(coffee);
    }
  }

  Future<void> addFavorite(Coffee coffee) async {
    final db = await _dbHelper.database;
    await db.insert('favorites', {'coffeeId': coffee.id});
    if (!_favorites.any((fav) => fav.id == coffee.id)) {
      _favorites.add(coffee);
      notifyListeners();
    }
  }

  Future<void> removeFavorite(String coffeeId) async {
    final db = await _dbHelper.database;
    await db.delete('favorites', where: 'coffeeId = ?', whereArgs: [coffeeId]);
    _favorites.removeWhere((fav) => fav.id == coffeeId);
    notifyListeners();
  }

  Future<void> clearFavorites() async {
    final db = await _dbHelper.database;
    await db.delete('favorites');
    _favorites.clear();
    notifyListeners();
  }
}