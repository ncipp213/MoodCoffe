class Coffee {
  final String id;
  final String name;
  final String description;
  final String price;
  final String imageUrl;
  final String category; // 'hot', 'cold', 'others'
  final double rating;

  Coffee({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.rating = 4.5,
  });
}

// Data contoh (semua kopi)
final List<Coffee> coffeeList = [
  Coffee(
    id: '1',
    name: 'Cappuccino',
    description: 'Rich espresso with creamy milk foam',
    price: 'Rp 28.000',
    imageUrl: 'https://images.unsplash.com/photo-1534778101976-62847782c213?w=200&h=200&fit=crop',
    category: 'hot',
    rating: 4.8,
  ),
  Coffee(
    id: '2',
    name: 'Gula Aren',
    description: 'Palm sugar sweetness with milk',
    price: 'Rp 25.000',
    imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=200&h=200&fit=crop',
    category: 'others',
    rating: 4.6,
  ),
  Coffee(
    id: '3',
    name: 'Latte',
    description: 'Smooth and creamy latte',
    price: 'Rp 30.000',
    imageUrl: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=200&h=200&fit=crop',
    category: 'hot',
    rating: 4.7,
  ),
  Coffee(
    id: '4',
    name: 'Ramell Latte',
    description: 'Caramel infused latte',
    price: 'Rp 32.000',
    imageUrl: 'https://images.unsplash.com/photo-1485808191679-5f86510681a2?w=200&h=200&fit=crop',
    category: 'hot',
    rating: 4.9,
  ),
  Coffee(
    id: '5',
    name: 'Coconut Cappuccino',
    description: 'with creamy coconut milk',
    price: 'Rp 33.000',
    imageUrl: 'https://images.unsplash.com/photo-1512568400610-62da28bc8a13?w=200&h=200&fit=crop',
    category: 'cold',
    rating: 4.8,
  ),
  Coffee(
    id: '6',
    name: 'Iced Americano',
    description: 'Refreshing cold brew',
    price: 'Rp 22.000',
    imageUrl: 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=200&h=200&fit=crop',
    category: 'cold',
    rating: 4.4,
  ),
];

// Daily specials (2 item pertama)
List<Coffee> get dailySpecials => coffeeList.take(2).toList();