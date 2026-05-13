class CartItem {
  final String id;
  final String name;
  final String imageUrl;
  final String milk; // Menyimpan pilihan: Classic, Coconut, atau Almond
  final String size; // Menyimpan pilihan: 280ml, 370ml, atau 450ml
  final int price;   // Harga harus dalam int agar bisa dijumlahkan secara matematis
  int quantity;      // Jumlah item yang dibeli

  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.milk,
    required this.size,
    required this.price,
    this.quantity = 1,
  });
}