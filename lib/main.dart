import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/orders.dart';
import 'package:shop_app/provider/products_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/main_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (context) => ProductsProvider('', '', []),
          update: (ctx, value, previous) => ProductsProvider(value.token!,
              value.userId!, previous == null ? [] : previous.items),
          // value: ProductsProvider(),
        ),
        ChangeNotifierProvider(
          // value: ProductsProvider(),
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders('', []),
          update: (context, value, previous) =>
              Orders(value.token!, previous == null ? [] : previous.orders),
        ),
        // value: ProductsProvider(),
      ],
      child: Consumer<Auth>(
        builder: (ctx, value, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: Colors.purple,
                    secondary: Colors.deepOrange,
                  ),
              fontFamily: GoogleFonts.archivo().fontFamily,
            ),
            home: value.isAuth ? const MainScreen() : const AuthScreen(),
            routes: {
              MainScreen.routeName: (context) => const MainScreen(),
              ProductDetailScreen.routeName: (context) =>
                  const ProductDetailScreen(),
              CartScreen.routeName: (context) => const CartScreen(),
              OrdersScreen.routeName: (context) => const OrdersScreen(),
              UserProductScreen.routeName: (context) =>
                  const UserProductScreen(),
              EditProductScreen.routeName: (context) =>
                  const EditProductScreen(),
              AuthScreen.routeName: (context) => const AuthScreen(),
            },
          );
        },
      ),
    );
  }
}
