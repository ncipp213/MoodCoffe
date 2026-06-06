import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  User? _currentUser;

  User? get currentUser => _currentUser;
  String get username => _currentUser?.username ?? '';
  String get email => _currentUser?.email ?? '';
  String get phone => _currentUser?.phone ?? '';
  String get address => _currentUser?.address ?? '';
  String get photoPath => _currentUser?.photoPath ?? '';

  /// Memuat data user dari database (panggil saat aplikasi mulai)
  Future<void> loadUser() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    if (maps.isNotEmpty) {
      _currentUser = User.fromMap(maps.first);
      notifyListeners();
    }
  }

  /// Login dengan email dan password
  Future<bool> login(String email, String password) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (maps.isNotEmpty) {
      _currentUser = User.fromMap(maps.first);
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Menyimpan profil (insert jika belum ada, update jika sudah)
  Future<void> saveProfile({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String photoPath,
    required String password,
  }) async {
    final db = await _dbHelper.database;
    final user = User(
      username: name,
      email: email,
      phone: phone,
      address: address,
      photoPath: photoPath,
      password: password,
    );

    // Cek apakah sudah ada user
    final existing = await db.query('users');
    if (existing.isEmpty) {
      // Insert baru
      final id = await db.insert('users', user.toMap());
      _currentUser = User(
        id: id,
        username: name,
        email: email,
        phone: phone,
        address: address,
        photoPath: photoPath,
        password: password,
      );
    } else {
      // Update yang sudah ada
      final id = existing.first['id'] as int;
      await db.update('users', user.toMap(), where: 'id = ?', whereArgs: [id]);
      _currentUser = User(
        id: id,
        username: name,
        email: email,
        phone: phone,
        address: address,
        photoPath: photoPath,
        password: password,
      );
    }
    notifyListeners();
  }

  /// Update profil (tanpa mengubah alamat, password tidak diubah)
  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String photoPath,
  }) async {
    if (_currentUser != null) {
      final updatedUser = User(
        id: _currentUser!.id,
        username: name,
        email: email,
        phone: phone,
        address: _currentUser!.address,
        photoPath: photoPath,
        password: _currentUser!.password, // gunakan password lama
      );
      final db = await _dbHelper.database;
      await db.update(
        'users',
        updatedUser.toMap(),
        where: 'id = ?',
        whereArgs: [_currentUser!.id],
      );
      _currentUser = updatedUser;
      notifyListeners();
    } else {
      throw Exception('Tidak dapat update profil karena belum login');
    }
  }

  /// Update username saja
  Future<void> updateUsername(String name) async {
    if (_currentUser != null) {
      final updatedUser = User(
        id: _currentUser!.id,
        username: name,
        email: _currentUser!.email,
        phone: _currentUser!.phone,
        address: _currentUser!.address,
        photoPath: _currentUser!.photoPath,
        password: _currentUser!.password,
      );
      final db = await _dbHelper.database;
      await db.update(
        'users',
        updatedUser.toMap(),
        where: 'id = ?',
        whereArgs: [_currentUser!.id],
      );
      _currentUser = updatedUser;
      notifyListeners();
    }
  }

  /// Update alamat saja
  Future<void> updateAddress(String newAddress) async {
    if (_currentUser != null) {
      final updatedUser = User(
        id: _currentUser!.id,
        username: _currentUser!.username,
        email: _currentUser!.email,
        phone: _currentUser!.phone,
        address: newAddress,
        photoPath: _currentUser!.photoPath,
        password: _currentUser!.password,
      );
      final db = await _dbHelper.database;
      await db.update(
        'users',
        updatedUser.toMap(),
        where: 'id = ?',
        whereArgs: [_currentUser!.id],
      );
      _currentUser = updatedUser;
      notifyListeners();
    }
  }

  /// Hapus profil (logout)
  Future<void> deleteProfile() async {
    if (_currentUser != null) {
      final db = await _dbHelper.database;
      await db.delete('users', where: 'id = ?', whereArgs: [_currentUser!.id]);
      _currentUser = null;
      notifyListeners();
    }
  }

  /// Cek apakah sudah ada profil
  Future<bool> hasProfile() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps.isNotEmpty;
  }
}