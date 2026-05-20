import 'dart:async';
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'succes_screen.dart';

class BarcodeScreen extends StatefulWidget {
  // Tambahkan parameter di constructor agar bisa menerima data dinamis
  final String orderId;
  final int totalPayment;

  const BarcodeScreen({
    super.key,
    required this.orderId,
    required this.totalPayment,
  });

  @override
  State<BarcodeScreen> createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {
  late Timer _timer;
  int _secondsRemaining = 300; // 5 menit

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

  // Fungsi untuk memformat mata uang rupiah secara manual
  String _formatRupiah(int amount) {
    String str = amount.toString();
    String result = '';
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      result = str[i] + result;
      count++;
      if (count == 3 && i != 0) {
        result = '.$result';
        count = 0;
      }
    }
    return 'Rp $result';
  }

  // Fungsi untuk merapikan tampilan teks barcode dengan spasi (opsional, agar mirip desain asli)
  String _formatBarcodeText(String text) {
    if (text.length <= 8) return text;
    // Memecah string menjadi potongan seperti format di gambar kamu (contoh: 2052026)
    try {
      return '${text.substring(0, 8)} ${text.substring(8, text.length - 6)} ${text.substring(text.length - 6)}';
    } catch (e) {
      return text; // Jika panjang karakter tidak sesuai, kembalikan teks asli
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Payment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF6F4E37),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ------------------- BAGIAN LOGO & BARCODE GARIS -------------------
              const Text(
                'MOODCOFFEE',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6F4E37),
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'NMID:ID1023304672596',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const Text(
                'A01',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              const Text(
                'BARCODE UNTUK BAYAR DI KASIR',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
              const SizedBox(height: 24),

              // --- SEKSI BARCODE GARIS-GARIS REAL & DINAMIS ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: BarcodeWidget(
                  barcode: Barcode.code128(), 
                  data: widget.orderId, // -> Sekarang datanya diambil dari variabel orderId dinamis
                  width: double.infinity,
                  height: 90, 
                  drawText: false, 
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Menampilkan teks nomor barcode secara dinamis
              Text(
                _formatBarcodeText(widget.orderId), // -> Teks barcode otomatis berganti sesuai order
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                textAlign: TextAlign.center,
              ),
              // -------------------------------------------------------------------

              const SizedBox(height: 30),

              // Kotak waktu pembayaran
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF0F0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF6F4E37).withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Selesaikan Waktu Pembayaran',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6F4E37),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _formatTime(_secondsRemaining),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Total Pembayaran Dinamis
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF0F0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF6F4E37).withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Pembayaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    Text(
                      _formatRupiah(widget.totalPayment), // -> Nominal pembayaran otomatis berganti
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6F4E37)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Tombol Cek Status Pembayaran
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6F4E37),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _secondsRemaining > 0
                      ? () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SuccessScreen()));
                        }
                      : null,
                  child: const Text(
                    'Cek Status Pembayaran',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}