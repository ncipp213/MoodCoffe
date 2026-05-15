import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  late Box<User> _userBox;
  User? _currentUser;

  UserProvider() {
    _init();
  }

  Future<void> _init() async {
    _userBox = Hive.box<User>('userBox');
    _loadUser();
  }

  void _loadUser() {
    if (_userBox.isNotEmpty) {
      _currentUser = _userBox.get('currentUser');
    }
    notifyListeners();
  }

  User? get currentUser => _currentUser;
  String get username => _currentUser?.username ?? '';
  String get email => _currentUser?.email ?? '';
  String get phone => _currentUser?.phone ?? '';
  String get address => _currentUser?.address ?? '';
  String get photoPath => _currentUser?.photoPath ?? '';

  // Create or Update Profile (menyimpan semua data)
  Future<void> saveProfile({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String photoPath,
  }) async {
    final user = User(
      username: name,
      email: email,
      phone: phone,
      address: address,
      photoPath: photoPath,
    );
    
    await _userBox.put('currentUser', user);
    _currentUser = user;
    notifyListeners();
  }

  // Method updateProfile yang dipanggil dari EditProfileScreen
  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String photoPath,
  }) async {
    if (_currentUser != null) {
      final updatedUser = User(
        username: name,
        email: email,
        phone: phone,
        address: _currentUser!.address,  // pertahankan address lama
        photoPath: photoPath,
      );
      await _userBox.put('currentUser', updatedUser);
      _currentUser = updatedUser;
      notifyListeners();
    } else {
      // Jika belum ada user, buat baru dengan address default
      await saveProfile(
        name: name,
        email: email,
        phone: phone,
        address: '',
        photoPath: photoPath,
      );
    }
  }

  // Update specific fields (contoh: hanya username)
  Future<void> updateUsername(String name) async {
    if (_currentUser != null) {
      final updatedUser = User(
        username: name,
        email: _currentUser!.email,
        phone: _currentUser!.phone,
        address: _currentUser!.address,
        photoPath: _currentUser!.photoPath,
      );
      await _userBox.put('currentUser', updatedUser);
      _currentUser = updatedUser;
      notifyListeners();
    }
  }

  // Update address saja
  Future<void> updateAddress(String newAddress) async {
    if (_currentUser != null) {
      final updatedUser = User(
        username: _currentUser!.username,
        email: _currentUser!.email,
        phone: _currentUser!.phone,
        address: newAddress,
        photoPath: _currentUser!.photoPath,
      );
      await _userBox.put('currentUser', updatedUser);
      _currentUser = updatedUser;
      notifyListeners();
    }
  }

  // Delete Profile
  Future<void> deleteProfile() async {
    await _userBox.delete('currentUser');
    _currentUser = null;
    notifyListeners();
  }

  // Check if user exists
  bool hasProfile() {
    return _currentUser != null;
  }
}