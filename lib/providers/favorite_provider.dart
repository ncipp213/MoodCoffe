import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/coffee.dart';

class FavoriteProvider with ChangeNotifier {
  late Box<Coffee> _favoritesBox;
  List<Coffee> _favorites = [];

  FavoriteProvider() {
    _init();
  }

  Future<void> _init() async {
    _favoritesBox = Hive.box<Coffee>('favoritesBox');
    _loadFavorites();
  }

  void _loadFavorites() {
    _favorites = _favoritesBox.values.toList();
    notifyListeners();
  }

  List<Coffee> get favorites => _favorites;

  bool isFavorite(Coffee coffee) {
    return _favorites.any((fav) => fav.id == coffee.id);
  }

  // Create & Delete: Toggle favorite
  Future<void> toggleFavorite(Coffee coffee) async {
    if (isFavorite(coffee)) {
      // Delete
      await _favoritesBox.delete(coffee.id);
      _favorites.removeWhere((fav) => fav.id == coffee.id);
    } else {
      // Create
      await _favoritesBox.put(coffee.id, coffee);
      _favorites.add(coffee);
    }
    notifyListeners();
  }

  // Create: Add favorite
  Future<void> addFavorite(Coffee coffee) async {
    if (!isFavorite(coffee)) {
      await _favoritesBox.put(coffee.id, coffee);
      _favorites.add(coffee);
      notifyListeners();
    }
  }

  // Delete: Remove favorite
  Future<void> removeFavorite(Coffee coffee) async {
    await _favoritesBox.delete(coffee.id);
    _favorites.removeWhere((fav) => fav.id == coffee.id);
    notifyListeners();
  }

  // Clear all favorites
  Future<void> clearFavorites() async {
    await _favoritesBox.clear();
    _favorites.clear();
    notifyListeners();
  }
}