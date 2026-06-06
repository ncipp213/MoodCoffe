// lib/providers/cart_provider.dart
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  /// Total harga semua item di keranjang
  int get totalAmount => _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  /// Jumlah item (bukan quantity, tapi jumlah unique item)
  int get itemCount => _items.length;

  /// Memuat keranjang dari database (panggil saat aplikasi mulai atau setelah perubahan)
  Future<void> loadCart() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('cart_items');
    _items = maps.map((map) => CartItem.fromMap(map)).toList();
    notifyListeners();
  }

  /// Menambahkan item ke keranjang
  Future<void> addItem(CartItem item) async {
    // Cek apakah item dengan id yang sama sudah ada? (opsional, bisa dicek dulu)
    // Untuk kasus ini, kita asumsikan setiap item unik (id berbeda)
    final db = await _dbHelper.database;
    await db.insert('cart_items', item.toMap());
    _items.add(item);
    notifyListeners();
  }

  /// Memperbarui kuantitas item tertentu
  Future<void> updateQuantity(String id, int newQuantity) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index].quantity = newQuantity;
      final db = await _dbHelper.database;
      await db.update(
        'cart_items',
        _items[index].toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
      notifyListeners();
    }
  }

  /// Menghapus satu item dari keranjang berdasarkan id
  Future<void> removeItem(String id) async {
    final db = await _dbHelper.database;
    await db.delete('cart_items', where: 'id = ?', whereArgs: [id]);
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  /// Mengosongkan seluruh keranjang
  Future<void> clearCart() async {
    final db = await _dbHelper.database;
    await db.delete('cart_items');
    _items.clear();
    notifyListeners();
  }

  /// Menambah quantity item (convenience method)
  Future<void> incrementQuantity(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      final newQty = _items[index].quantity + 1;
      await updateQuantity(id, newQty);
    }
  }

  /// Mengurangi quantity item, jika quantity > 1, jika 1 maka hapus item
  Future<void> decrementQuantity(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        final newQty = _items[index].quantity - 1;
        await updateQuantity(id, newQty);
      } else {
        await removeItem(id);
      }
    }
  }

  /// Mendapatkan jumlah total item (menjumlah semua quantity)
  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);
}