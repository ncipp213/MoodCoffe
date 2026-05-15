import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'providers/cart_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/user_provider.dart';
import 'screens/login_screen.dart';
import 'models/user.dart';
import 'models/cart_item.dart';
import 'models/coffee.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi Hive
  await Hive.initFlutter();
  
  // Daftarkan adapters
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(CartItemAdapter());
  Hive.registerAdapter(CoffeeAdapter());
  
  // Buka boxes
  await Hive.openBox<User>('userBox');
  await Hive.openBox<CartItem>('cartBox');
  await Hive.openBox<Coffee>('favoritesBox');
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
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