import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/coffee.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // Menghitung total harga
  int get totalAmount {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Alias untuk totalAmount agar sinkron dengan file lain
  int get totalPrice => totalAmount;

  // FUNGSI UTAMA: Tambah ke Keranjang
  void addItem(Coffee coffee, String milk, String size) {
    // Cek apakah item dengan kombinasi yang sama sudah ada
    int index = _items.indexWhere((i) => 
      i.name == coffee.name && i.milk == milk && i.size == size);

    if (index >= 0) {
      // Jika sudah ada, cukup tambah jumlahnya
      _items[index].quantity += 1;
    } else {
      // Jika belum ada, buat CartItem baru
      _items.add(
        CartItem(
          // Menambahkan ID unik menggunakan timestamp agar tidak error 'missing_required_argument'
          id: DateTime.now().millisecondsSinceEpoch.toString(), 
          name: coffee.name,
          // Mengonversi String harga ke Integer agar bisa dihitung
          price: int.parse(coffee.price), 
          // Pastikan menggunakan 'image' atau 'imageUrl' sesuai model Coffee kamu
          imageUrl: coffee.imageUrl, 
          milk: milk,
          size: size,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  // Fungsi update jumlah (tambah/kurang)
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

  // Fungsi hapus item
  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  // Fungsi bantuan jika kamu masih menggunakan parameter CartItem langsung
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