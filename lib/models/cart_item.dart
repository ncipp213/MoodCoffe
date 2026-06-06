// lib/models/cart_item.dart

class CartItem {
  final String id;
  final String name;
  final String imageUrl;
  final String milk;
  final String size;
  final int price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.milk,
    required this.size,
    required this.price,
    this.quantity = 1,
  });

  /// Konversi objek CartItem ke Map untuk SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'milk': milk,
      'size': size,
      'price': price,
      'quantity': quantity,
    };
  }

  /// Membuat objek CartItem dari Map hasil query SQLite
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      milk: map['milk'],
      size: map['size'],
      price: map['price'],
      quantity: map['quantity'],
    );
  }
}