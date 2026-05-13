import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/coffee.dart';
import '../widgets/coffee_card.dart';
import '../providers/cart_provider.dart';
import 'detail_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'all';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Logika Filter Pencarian dan Kategori
  List<Coffee> get _filteredCoffee {
    List<Coffee> filtered = coffeeList;
    if (_selectedCategory != 'all') {
      filtered = filtered.where((coffee) => coffee.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((coffee) => coffee.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return filtered;
  }

  void _navigateToDetail(Coffee coffee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoffeeDetailScreen(coffee: coffee),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header: Salam, Notifikasi, Search, Banner, dan Filter
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Hey,', style: TextStyle(fontSize: 14, color: Colors.grey)),
                            Text(widget.username, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6F4E37).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.notifications_none, color: Color(0xFF6F4E37)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text('Pilih seduhan favoritmu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _searchQuery = value),
                      decoration: InputDecoration(
                        hintText: 'Search for coffee',
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF6F4E37), Color(0xFF8D6E63)]),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text('moodcoffee ☕', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 24),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildChip('all', 'All'),
                          const SizedBox(width: 8),
                          _buildChip('hot', 'Hot coffee'),
                          const SizedBox(width: 8),
                          _buildChip('cold', 'Cold coffee'),
                          const SizedBox(width: 8),
                          _buildChip('others', 'Others'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            
            // Bagian Recommended (Horizontal List)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Recommended for you', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 250, // Tinggi ditambah agar tidak overflow
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: coffeeList.take(5).length,
                      itemBuilder: (context, index) => CoffeeCard(
                        coffee: coffeeList[index],
                        onTap: () => _navigateToDetail(coffeeList[index]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Bagian Menu Utama (Grid View)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Menu Kopi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.68, // DIPERBAIKI: Rasio dikecilkan agar kotak lebih panjang dan tidak kuning
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: _filteredCoffee.length,
                      itemBuilder: (context, index) => CoffeeCard(
                        coffee: _filteredCoffee[index],
                        onTap: () => _navigateToDetail(_filteredCoffee[index]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)), // Spacer bawah
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF6F4E37),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorites'),
          // Ikon Cart dengan Badge Notifikasi otomatis
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(
              builder: (context, cart, child) {
                return Badge(
                  label: Text(cart.items.length.toString()),
                  isLabelVisible: cart.items.isNotEmpty,
                  backgroundColor: const Color(0xFF6F4E37),
                  child: const Icon(Icons.shopping_bag_outlined),
                );
              },
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
        onTap: (index) {
          if (index == 2) { // Navigasi ke Halaman Cart
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _buildChip(String value, String label) {
    return FilterChip(
      label: Text(label),
      selected: _selectedCategory == value,
      onSelected: (selected) => setState(() => _selectedCategory = selected ? value : 'all'),
      backgroundColor: Colors.grey.shade100,
      selectedColor: const Color(0xFF6F4E37).withOpacity(0.2),
      checkmarkColor: const Color(0xFF6F4E37),
      labelStyle: TextStyle(
        color: _selectedCategory == value ? const Color(0xFF6F4E37) : Colors.grey.shade700,
        fontWeight: _selectedCategory == value ? FontWeight.bold : null,
      ),
    );
  }
}