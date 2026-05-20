import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_counter.dart';
import 'barcode_screen.dart';
import 'qris_screen.dart';
import 'order_history_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _orderType = 'DINE IN';
  String _paymentMethod = '';
  final int _shippingCost = 2000;

  String formatPrice(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[month - 1];
  }

  void _saveOrderToHistory(CartProvider cartProvider, OrderCounter orderCounter) {
    if (cartProvider.items.isEmpty) return;

    final items = cartProvider.items.map((item) {
      return {
        'name': item.name,
        'price': item.price,
        'quantity': item.quantity,
        'size': item.size.isNotEmpty ? item.size : 'Regular',
        'milk': item.milk,
      };
    }).toList();

    final subtotal = cartProvider.totalPrice;
    final total = subtotal + _shippingCost;
    final now = DateTime.now();
    final orderId = orderCounter.nextOrderId;

    final newOrder = {
      'orderId': orderId,
      'date': '${now.day} ${_getMonthName(now.month)} ${now.year}',
      'time': '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      'items': items,
      'total': total,
      'paymentMethod': _paymentMethod,
      'orderType': _orderType,
    };

    cartProvider.clearCart();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderHistoryScreen(newOrder: newOrder),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;
    final subtotal = cartProvider.totalPrice;
    final total = subtotal + _shippingCost;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF0F0),
      appBar: AppBar(
        title: const Text('Payment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF6F4E37),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Keranjang kosong', style: TextStyle(fontSize: 16)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tipe Pemesanan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF3E2723))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _buildOrderTypeCard('DINE IN', Icons.restaurant, _orderType == 'DINE IN')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildOrderTypeCard('TAKE AWAY', Icons.shopping_bag, _orderType == 'TAKE AWAY')),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Text('Metode Pembayaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF3E2723))),
                  const SizedBox(height: 8),
                  _buildPaymentMethodCard('BAYAR DI KASIR', Icons.payments, _paymentMethod == 'BAYAR DI KASIR'),
                  const SizedBox(height: 12),
                  _buildPaymentMethodCard('QRIS', Icons.qr_code_scanner, _paymentMethod == 'QRIS'),
                  const SizedBox(height: 30),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      children: [
                        if (cartItems.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Pesanan Anda', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cartItems.length,
                            separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.5),
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              final subtotalItem = item.price * item.quantity;
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                          Text('${item.milk} • ${item.size}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                          Text('Jumlah: ${item.quantity}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(formatPrice(item.price), style: const TextStyle(fontSize: 12)),
                                          const SizedBox(height: 4),
                                          Text(formatPrice(subtotalItem), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF6F4E37))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const Divider(height: 1, thickness: 1),
                        ],
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildPriceRow('Shipping cost', formatPrice(_shippingCost)),
                              const SizedBox(height: 8),
                              _buildPriceRow('Subtotal', formatPrice(subtotal)),
                              const Divider(height: 24, thickness: 1),
                              _buildPriceRow('Total', formatPrice(total), isTotal: true),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6F4E37),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ).copyWith(
                        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                          if (states.contains(MaterialState.pressed)) return Colors.white.withValues(alpha: 0.3);
                          return null;
                        }),
                        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                          if (states.contains(MaterialState.pressed)) return const Color(0xFF8D6E63);
                          return const Color(0xFF6F4E37);
                        }),
                      ),
                      onPressed: _paymentMethod.isEmpty
                          ? null
                          : () {
                              final orderCounter = Provider.of<OrderCounter>(context, listen: false);
                              _saveOrderToHistory(cartProvider, orderCounter);
                            },
                      child: const Text('Place order', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  if (_paymentMethod.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text('Pilih metode pembayaran terlebih dahulu', style: TextStyle(color: Colors.red, fontSize: 12)),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildOrderTypeCard(String title, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _orderType = title),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6F4E37) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.white : const Color(0xFF6F4E37), size: 28),
            const SizedBox(height: 6),
            Text(title, style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF3E2723), fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(String title, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = title),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6F4E37).withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFF6F4E37) : Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF6F4E37) : Colors.grey.shade600),
            const SizedBox(width: 12),
            Text(title, style: TextStyle(color: isSelected ? const Color(0xFF6F4E37) : const Color(0xFF3E2723), fontWeight: FontWeight.w500)),
            const Spacer(),
            if (isSelected) const Icon(Icons.check_circle, color: Color(0xFF6F4E37), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: isTotal ? 18 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(fontSize: isTotal ? 18 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.w500)),
      ],
    );
  }
}