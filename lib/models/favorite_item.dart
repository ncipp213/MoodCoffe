import 'package:hive/hive.dart';

part 'favorite_item.g.dart';

@HiveType(typeId: 2)
class FavoriteItem {
  @HiveField(0)
  int id;
  
  @HiveField(1)
  String name;
  
  @HiveField(2)
  int price;
  
  @HiveField(3)
  String imageUrl;

  FavoriteItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}