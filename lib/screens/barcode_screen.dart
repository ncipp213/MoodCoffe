import 'dart:async';
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'succes_screen.dart';

class BarcodeScreen extends StatefulWidget {
  final String orderId;
  final int totalPayment;
  final Map<String, dynamic>? newOrder;

  const BarcodeScreen({
    super.key,
    required this.orderId,
    required this.totalPayment,
    this.newOrder,
  });

  @override
  State<BarcodeScreen> createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {
  late Timer _timer;
  int _secondsRemaining = 393;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        if (mounted) setState(() => _secondsRemaining--);
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _formatRupiah(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    const Color coffeeBrown = Color(0xFF6F4E37);
    const Color darkBrown = Color(0xFF3E2723);
    const Color creamBg = Color(0xFFFDF0F0);

    return Scaffold(
      backgroundColor: creamBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: darkBrown),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Payment", style: TextStyle(color: darkBrown, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // BOX TIMER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(color: darkBrown, borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  const Text('Selesaikan Waktu Pembayaran', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  Text(_formatTime(_secondsRemaining), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          // LOGO & INFO
          const Text('MOODCOFFEE', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: coffeeBrown, letterSpacing: 1.5)),
          const Text('NMID : ID1023304672596', style: TextStyle(fontSize: 12, color: darkBrown)),
          const SizedBox(height: 20),
          const Text('BARCODE UNTUK BAYAR DI KASIR', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black45)),
          // BARCODE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: BarcodeWidget(
              barcode: Barcode.code128(),
              data: widget.orderId,
              height: 100,
              width: double.infinity,
              drawText: false,
            ),
          ),
          Text(widget.orderId, style: const TextStyle(fontWeight: FontWeight.w500, color: darkBrown)),
          const SizedBox(height: 30),
          // TOTAL PEMBAYARAN
          const Text('Total Pembayaran', style: TextStyle(fontSize: 16, color: coffeeBrown)),
          Text(_formatRupiah(widget.totalPayment), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: coffeeBrown)),
          
          const Spacer(), // <--- Ini yang mendorong tombol ke bawah

          // TOMBOL-TOMBOL (Cek Status & Download)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    height: 60,
                    child: Builder(
                      builder: (newContext) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: coffeeBrown, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                          onPressed: () {
                            showDialog(context: newContext, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator(color: coffeeBrown)));
                            Future.delayed(const Duration(milliseconds: 1500), () {
                              Navigator.pop(newContext);
                              Navigator.pushReplacement(newContext, MaterialPageRoute(builder: (_) => SuccessScreen(orderData: widget.newOrder)));
                            });
                          },
                          child: const Text('Cek Status Pembayaran', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(height: 60, width: 60, decoration: BoxDecoration(color: darkBrown, borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.download_rounded, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}