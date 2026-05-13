import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment'), backgroundColor: Colors.brown),
      body: const Center(child: Text('Halaman Payment (masih dalam pengembangan)')),
    );
  }
}