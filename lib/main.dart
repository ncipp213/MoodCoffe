import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart'; // 1. Tambahkan ini
import 'providers/cart_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/user_provider.dart'; 
import 'providers/order_counter.dart';
import 'screens/login_screen.dart';

void main() async { // 2. Tambahkan async
  WidgetsFlutterBinding.ensureInitialized(); // 3. Tambahkan ini

  // 4. Inisialisasi Hive
  await Hive.initFlutter(); 
  
  // 5. Buka box 'order_history' agar selalu tersedia
  await Hive.openBox('order_history'); 

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => OrderCounter()),
      ],
      child: const CoffeeShopApp(),
    ),
  );
}

class CoffeeShopApp extends StatelessWidget {
  const CoffeeShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Coffee',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6F4E37),
          primary: const Color(0xFF6F4E37),
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}