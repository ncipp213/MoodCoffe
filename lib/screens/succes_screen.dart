import 'package:flutter/material.dart';
import 'home_screen.dart';

class SuccessScreen extends StatelessWidget {
  final Map<String, dynamic>? orderData; // Menampung data orderan

  const SuccessScreen({super.key, this.orderData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Sukses', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF6F4E37),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 100),
              const SizedBox(height: 24),
              const Text(
                'Pembayaran Berhasil!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF3E2723)),
              ),
              const SizedBox(height: 12),
              // Menampilkan ID Order jika ada
              if (orderData != null)
                Text('ID Pesanan: ${orderData!['orderId']}', style: const TextStyle(fontSize: 16, color: Colors.black54)),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6F4E37),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen(username: 'Afiiwwww')),
                    (route) => false,
                  );
                },
                child: const Text('Kembali ke Beranda', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}