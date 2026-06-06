// lib/models/user.dart

class User {
  int? id; // Primary key untuk SQLite (auto increment)
  String username;
  String email;
  String phone;
  String address;
  String? photoPath;
  String password; // Field password untuk autentikasi

  User({
    this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.address,
    this.photoPath,
    required this.password, // Wajib diisi saat membuat User
  });

  /// Konversi objek User ke Map untuk SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'address': address,
      'photoPath': photoPath,
      'password': password, // Kolom password disertakan
    };
  }

  /// Membuat objek User dari Map hasil query SQLite
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      photoPath: map['photoPath'],
      password: map['password'], // Password diambil dari database
    );
  }
}