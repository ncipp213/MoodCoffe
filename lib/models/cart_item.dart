import 'package:hive/hive.dart';

part 'cart_item.g.dart'; 

@HiveType(typeId: 2) 
class CartItem {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String imageUrl;
  
  @HiveField(3)
  final String milk;
  
  @HiveField(4)
  final String size;
  
  @HiveField(5)
  final int price;
  
  @HiveField(6)
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
}