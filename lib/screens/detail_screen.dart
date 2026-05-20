import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/coffee.dart';
import '../providers/cart_provider.dart';
import '../providers/favorite_provider.dart';
import 'payment_screen.dart';

class CoffeeDetailScreen extends StatefulWidget {
  final Coffee coffee;
  const CoffeeDetailScreen({super.key, required this.coffee});

  @override
  State<CoffeeDetailScreen> createState() => _CoffeeDetailScreenState();
}

class _CoffeeDetailScreenState extends State<CoffeeDetailScreen> {
  String selectedMilk = 'Classic';
  String selectedSize = '370ml';
  int basePrice = 0;

  @override
  void initState() {
    super.initState();
    basePrice = _extractPrice(widget.coffee.price);
  }

  int _extractPrice(dynamic price) {
    if (price is int) return price;
    if (price is String) {
      final numeric = price.replaceAll(RegExp(r'[^0-9]'), '');
      return int.tryParse(numeric) ?? 0;
    }
    return 0;
  }

  int getCurrentPrice() {
    switch (selectedSize) {
      case '280ml':
        return basePrice - 5000;
      case '450ml':
        return basePrice + 5000;
      default:
        return basePrice;
    }
  }

  String _formatPrice(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  void _addToCart() {
    final currentPrice = getCurrentPrice();
    final coffeeWithPrice = Coffee(
      id: widget.coffee.id,
      name: widget.coffee.name,
      description: widget.coffee.description,
      price: currentPrice.toString(),
      imageUrl: widget.coffee.imageUrl,
      category: widget.coffee.category,
      rating: widget.coffee.rating,
    );
    Provider.of<CartProvider>(context, listen: false).addItem(
      coffeeWithPrice,
      selectedMilk,
      selectedSize,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.coffee.name} ($selectedSize) ditambahkan ke keranjang'),
        backgroundColor: const Color(0xFF6F4E37),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _orderNow() {
    final currentPrice = getCurrentPrice();
    final coffeeWithPrice = Coffee(
      id: widget.coffee.id,
      name: widget.coffee.name,
      description: widget.coffee.description,
      price: currentPrice.toString(),
      imageUrl: widget.coffee.imageUrl,
      category: widget.coffee.category,
      rating: widget.coffee.rating,
    );
    Provider.of<CartProvider>(context, listen: false).addItem(
      coffeeWithPrice,
      selectedMilk,
      selectedSize,
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaymentScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final isFav = favoriteProvider.isFavorite(widget.coffee);
    final currentPrice = getCurrentPrice();

    return Scaffold(
      backgroundColor: const Color(0xFFFDF0F0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: screenHeight * 0.4,
                  width: double.infinity,
                  child: Image.network(widget.coffee.imageUrl, fit: BoxFit.cover),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white.withValues(alpha: 0.7),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white.withValues(alpha: 0.7),
                          child: IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : Colors.black,
                            ),
                            onPressed: () {
                              favoriteProvider.toggleFavorite(widget.coffee);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.coffee.name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            widget.coffee.rating.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    widget.coffee.description,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 25),
                  const Text("Milk", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildOptionChip("Classic", selectedMilk == "Classic", (val) => setState(() => selectedMilk = val)),
                      _buildOptionChip("Coconut", selectedMilk == "Coconut", (val) => setState(() => selectedMilk = val)),
                      _buildOptionChip("Almond", selectedMilk == "Almond", (val) => setState(() => selectedMilk = val)),
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Text("Size", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildOptionChip("280ml", selectedSize == "280ml", (val) => setState(() => selectedSize = val)),
                      _buildOptionChip("370ml", selectedSize == "370ml", (val) => setState(() => selectedSize = val)),
                      _buildOptionChip("450ml", selectedSize == "450ml", (val) => setState(() => selectedSize = val)),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // Tampilkan Harga
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Harga:",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _formatPrice(currentPrice),
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF6F4E37)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF424242),
                  side: const BorderSide(color: Color(0xFF424242)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: _addToCart,
                child: const Text("Add to Cart", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF424242),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: _orderNow,
                child: const Text("Order Now", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionChip(String label, bool isSelected, Function(String) onSelected) {
    return GestureDetector(
      onTap: () => onSelected(label),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6F4E37) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}