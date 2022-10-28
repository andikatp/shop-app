import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products_provider.dart';
import 'package:shop_app/screens/main_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductsProvider(),
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Colors.purple,
                secondary: Colors.deepOrange,
              ),
          fontFamily: GoogleFonts.archivo().fontFamily,
        ),
        home: MainScreen(),
        routes: {
          MainScreen.routeName: (context) => MainScreen(),
          ProductDetailScreen.routeName: (context) => const ProductDetailScreen(),
        },
      ),
    );
  }
}
