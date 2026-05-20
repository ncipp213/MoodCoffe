import 'package:flutter/material.dart';

class OrderCounter extends ChangeNotifier {
  int _currentNumber = 1;
  
  int get currentNumber => _currentNumber;
  
  String get nextOrderId {
    final orderId = 'ORD-${_currentNumber.toString().padLeft(3, '0')}';
    _currentNumber++;
    notifyListeners();
    return orderId;
  }
  
  void reset() {
    _currentNumber = 1;
    notifyListeners();
  }
}