import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/coffee.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get totalAmount {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  int get totalPrice => totalAmount;

  // Helper: ekstrak angka dari string harga (contoh: "Rp 28.000" -> 28000)
  int _extractNumberFromPrice(String priceString) {
    final numeric = priceString.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(numeric) ?? 0;
  }

  void addItem(Coffee coffee, String milk, String size) {
    int index = _items.indexWhere((i) => 
      i.name == coffee.name && i.milk == milk && i.size == size);

    if (index >= 0) {
      _items[index].quantity += 1;
    } else {
      _items.add(
        CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: coffee.name,
          price: _extractNumberFromPrice(coffee.price),
          imageUrl: coffee.imageUrl,
          milk: milk,
          size: size,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void updateQuantity(int index, bool isIncrement) {
    if (isIncrement) {
      _items[index].quantity++;
    } else {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      }
    }
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  // ✅ METHOD CLEAR CART (TAMBAHAN)
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void addToCart(CartItem newItem) {
    int index = _items.indexWhere((i) => 
      i.name == newItem.name && i.milk == newItem.milk && i.size == newItem.size);

    if (index >= 0) {
      _items[index].quantity += 1;
    } else {
      _items.add(newItem);
    }
    notifyListeners();
  }
}