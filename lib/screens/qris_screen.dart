import 'package:flutter/material.dart';

class QrisScreen extends StatelessWidget {
  const QrisScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QRIS Payment'), backgroundColor: const Color(0xFF6F4E37)),
      body: const Center(child: Text('Halaman QRIS (belum tersedia)', style: TextStyle(fontSize: 18))),
    );
  }
}