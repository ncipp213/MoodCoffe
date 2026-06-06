// success_screen.dart
import 'package:flutter/material.dart';
import 'order_history_screen.dart';

class SuccessScreen extends StatelessWidget {
  final Map<String, dynamic>? orderData;

  const SuccessScreen({super.key, this.orderData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Sukses'),
        backgroundColor: const Color(0xFF6F4E37),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 24),
            const Text('Pembayaran Berhasil!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Arahkan ke OrderHistoryScreen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderHistoryScreen(newOrder: orderData),
                  ),
                );
              },
              child: const Text('Lihat History Pesanan'),
            ),
          ],
        ),
      ),
    );
  }
}