import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatefulWidget {
  final Map<String, dynamic>? newOrder;
  
  const OrderHistoryScreen({super.key, this.newOrder});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  // Data contoh (sudah diurutkan dari terbaru ke terlama)
  List<Map<String, dynamic>> orders = [
    {
      'orderId': 'ORD-003',
      'date': '20 Mei 2026',
      'time': '19:45',
      'items': [
        {'name': 'Americano', 'price': 23000, 'quantity': 1, 'size': '280ml', 'milk': 'Classic'},
        {'name': 'Cappuccino', 'price': 25000, 'quantity': 1, 'size': '370ml', 'milk': 'Classic'},
      ],
      'total': 48000,
      'paymentMethod': 'QRIS',
      'orderType': 'DINE IN',
    },
    {
      'orderId': 'ORD-002',
      'date': '18 Mei 2026',
      'time': '09:15',
      'items': [
        {'name': 'Latte', 'price': 24000, 'quantity': 1, 'size': '370ml', 'milk': 'Almond'},
      ],
      'total': 24000,
      'paymentMethod': 'BAYAR DI KASIR',
      'orderType': 'TAKE AWAY',
    },
    {
      'orderId': 'ORD-001',
      'date': '15 Mei 2026',
      'time': '14:30',
      'items': [
        {'name': 'Cappuccino', 'price': 25000, 'quantity': 1, 'size': '370ml', 'milk': 'Classic'},
        {'name': 'Gula aren', 'price': 23000, 'quantity': 2, 'size': '450ml', 'milk': 'Coconut'},
      ],
      'total': 71000,
      'paymentMethod': 'QRIS',
      'orderType': 'DINE IN',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Cek apakah ada order baru yang dikirim
    if (widget.newOrder != null) {
      // Tunggu sebentar lalu tambahkan order
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          orders.insert(0, widget.newOrder!);
        });
        // Tampilkan notifikasi
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Pesanan berhasil disimpan ke history'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      });
    }
  }

  String formatPrice(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  int getTotalSpending() {
    return orders.fold(0, (sum, order) => sum + (order['total'] as int));
  }

  @override
  Widget build(BuildContext context) {
    final totalSpending = getTotalSpending();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // latar abu-abu muda
      appBar: AppBar(
        title: const Text('Order History', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF6F4E37),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // --- Card Header dengan Gradien Warna ---
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD4A373), Color(0xFFBC6C25)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '💰 Total Pengeluaran',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  formatPrice(totalSpending),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // --- Daftar Riwayat Pesanan ---
          Expanded(
            child: orders.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Belum ada riwayat pesanan', style: TextStyle(fontSize: 16, color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final items = order['items'] as List;
                      final total = order['total'] as int;
                      final date = order['date'];
                      final time = order['time'];
                      final paymentMethod = order['paymentMethod'];
                      final orderType = order['orderType'];

                      // Warna aksen berdasarkan tipe pemesanan
                      final Color orderTypeColor = orderType == 'DINE IN' ? Colors.green.shade700 : Colors.orange.shade700;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 3,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Baris atas: Tanggal, Jam, dan Order ID
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text('$date', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text('$time', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF6F4E37).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      order['orderId'],
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF6F4E37)),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 20, thickness: 1),
                              // Daftar item
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: items.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 8),
                                itemBuilder: (_, i) {
                                  final item = items[i];
                                  return Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                            Text(
                                              '${item['size']} • ${item['milk']} • ${item['quantity']}x',
                                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          formatPrice(item['price'] * item['quantity']),
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFFBC6C25)),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const Divider(height: 20, thickness: 1),
                              // Informasi metode, tipe, dan total
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Metode pembayaran dengan ikon
                                  Row(
                                    children: [
                                      Icon(
                                        paymentMethod == 'QRIS' ? Icons.qr_code_scanner : Icons.payments,
                                        size: 16,
                                        color: Colors.grey.shade600,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(paymentMethod, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                                    ],
                                  ),
                                  // Tipe pemesanan dengan warna
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: orderTypeColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: orderTypeColor.withOpacity(0.5)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(orderType == 'DINE IN' ? Icons.restaurant : Icons.shopping_bag, size: 12, color: orderTypeColor),
                                        const SizedBox(width: 4),
                                        Text(orderType, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: orderTypeColor)),
                                      ],
                                    ),
                                  ),
                                  // Total pesanan
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text('Total', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                      const SizedBox(height: 2),
                                      Text(
                                        formatPrice(total),
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF6F4E37)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}