import 'package:hive/hive.dart';

part 'user.g.dart'; 

@HiveType(typeId: 0) 
class User {
  @HiveField(0)
  String fullname;
  
  @HiveField(1)
  String email;
  
  @HiveField(2)
  String phone;
  
  @HiveField(3)
  String address;
  
  @HiveField(4)
  String? avatarPath; // Nullable, tidak wajib diisi

  User({
    required this.fullname,
    required this.email,
    required this.phone,
    required this.address,
    this.avatarPath,
  });
}