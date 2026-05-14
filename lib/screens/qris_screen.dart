import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; //
import '../providers/cart_provider.dart'; //
import 'succes_screen.dart'; //

class QrisScreen extends StatefulWidget {
  const QrisScreen({super.key});

  @override
  State<QrisScreen> createState() => _QrisScreenState();
}

class _QrisScreenState extends State<QrisScreen> {
  Duration _duration = const Duration(minutes: 6, seconds: 50);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds > 0) {
        if (mounted) {
          setState(() {
            _duration -= const Duration(seconds: 1);
          });
        }
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    // MENGAMBIL DATA DARI PROVIDER TEMANMU
    final cartProvider = context.watch<CartProvider>(); //
    final int totalHarga = cartProvider.totalPrice; //

    // PALET WARNA COKLAT (Mood Coffee Style)
    const Color coffeeBrown = Color(0xFF6F4E37); // Coklat Kopi
    const Color darkBrown = Color(0xFF3E2723);   // Coklat Gelap (Ganti Abu-abu)
    const Color creamBg = Color(0xFFFFF5E1);     // Background Cream

    return Scaffold(
      backgroundColor: creamBg, //
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: darkBrown, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Payment",
          style: TextStyle(color: darkBrown, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            
            // BOX TIMER (COKLAT GELAP)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 15),
              width: double.infinity,
              decoration: BoxDecoration(
                color: darkBrown, //
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const Text(
                    "Selesaikan Waktu Pembayaran",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Text(
                    _formatDuration(_duration),
                    style: const TextStyle(
                      color: Colors.white, 
                      fontSize: 22, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            
            // LOGO & INFO
            const Text(
              "MOODCOFFEE",
              style: TextStyle(
                fontSize: 28, 
                fontWeight: FontWeight.bold, 
                color: coffeeBrown,
                letterSpacing: 1.5
              ),
            ),
            const Text("NMID : ID1023304672596", style: TextStyle(fontSize: 12, color: darkBrown)),
            const Text("Kasir: A01", style: TextStyle(fontSize: 12, color: darkBrown)),

            const SizedBox(height: 25),
            
            // QR CODE BOX
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: coffeeBrown.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Image.network(
                'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=MoodCoffeePayment',
                width: 200,
                height: 200,
              ),
            ),

            const SizedBox(height: 35),
            const Text("Total Pembayaran", style: TextStyle(fontSize: 16, color: coffeeBrown)),
            
            // HARGA DARI PROVIDER
            Text(
              "Rp ${totalHarga.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
              style: const TextStyle(
                fontSize: 26, 
                fontWeight: FontWeight.bold, 
                color: coffeeBrown
              ),
            ),

            const SizedBox(height: 50),
            
            // TOMBOL AKSI (COKLAT)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SuccessScreen()), //
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: coffeeBrown, //
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text(
                          "Cek Status Pembayaran", 
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // TOMBOL DOWNLOAD
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: darkBrown, //
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.download_rounded, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}