import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/cart_item.dart';
import '../models/coffee.dart';

class CartProvider with ChangeNotifier {
  late Box<CartItem> _cartBox;
  List<CartItem> _items = [];

  CartProvider() {
    _init();
  }

  Future<void> _init() async {
    _cartBox = Hive.box<CartItem>('cartBox');
    _loadCart();
  }

  void _loadCart() {
    _items = _cartBox.values.toList();
    notifyListeners();
  }

  List<CartItem> get items => _items;

  int get totalAmount {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  int get totalPrice => totalAmount;

  int _extractNumberFromPrice(String priceString) {
    final numeric = priceString.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(numeric) ?? 0;
  }

  // Create: Add item to cart
  Future<void> addItem(Coffee coffee, String milk, String size) async {
    int index = _items.indexWhere((i) => 
      i.name == coffee.name && i.milk == milk && i.size == size);
    
    if (index >= 0) {
      // Update existing item
      _items[index].quantity += 1;
      await _cartBox.put(_items[index].id, _items[index]);
    } else {
      // Create new item
      final newItem = CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: coffee.name,
        price: _extractNumberFromPrice(coffee.price),
        imageUrl: coffee.imageUrl,
        milk: milk,
        size: size,
        quantity: 1,
      );
      _items.add(newItem);
      await _cartBox.put(newItem.id, newItem);
    }
    notifyListeners();
  }

  // Update: Update quantity
  Future<void> updateQuantity(int index, bool isIncrement) async {
    if (isIncrement) {
      _items[index].quantity++;
    } else {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      }
    }
    await _cartBox.put(_items[index].id, _items[index]);
    notifyListeners();
  }

  // Delete: Remove item from cart
  Future<void> removeItem(int index) async {
    final itemId = _items[index].id;
    await _cartBox.delete(itemId);
    _items.removeAt(index);
    notifyListeners();
  }

  // Clear all cart
  Future<void> clearCart() async {
    await _cartBox.clear();
    _items.clear();
    notifyListeners();
  }

  // Add to cart using CartItem object
  Future<void> addToCart(CartItem newItem) async {
    int index = _items.indexWhere((i) => 
      i.name == newItem.name && i.milk == newItem.milk && i.size == newItem.size);
    
    if (index >= 0) {
      _items[index].quantity += 1;
      await _cartBox.put(_items[index].id, _items[index]);
    } else {
      _items.add(newItem);
      await _cartBox.put(newItem.id, newItem);
    }
    notifyListeners();
  }
}