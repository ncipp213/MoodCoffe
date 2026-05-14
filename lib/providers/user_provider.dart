import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _username = '';
  String _email = '';
  String _phone = '';
  String _photoPath = '';

  String get username => _username;
  String get email => _email;
  String get phone => _phone;
  String get photoPath => _photoPath;

  void setUsername(String name) {
    _username = name;
    notifyListeners();
  }

  void updateProfile({
    required String name,
    required String email,
    required String phone,
    required String photoPath,
  }) {
    _username = name;
    _email = email;
    _phone = phone;
    _photoPath = photoPath;
    notifyListeners();
  }
}