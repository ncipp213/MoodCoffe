import 'package:flutter/material.dart';
import '../models/coffee.dart';

class FavoriteProvider with ChangeNotifier {
  final List<Coffee> _favorites = [];

  List<Coffee> get favorites => _favorites;

  bool isFavorite(Coffee coffee) {
    return _favorites.any((fav) => fav.id == coffee.id);
  }

  void toggleFavorite(Coffee coffee) {
    if (isFavorite(coffee)) {
      _favorites.removeWhere((fav) => fav.id == coffee.id);
    } else {
      _favorites.add(coffee);
    }
    notifyListeners();
  }

  void addFavorite(Coffee coffee) {
    if (!isFavorite(coffee)) {
      _favorites.add(coffee);
      notifyListeners();
    }
  }

  void removeFavorite(Coffee coffee) {
    _favorites.removeWhere((fav) => fav.id == coffee.id);
    notifyListeners();
  }
}