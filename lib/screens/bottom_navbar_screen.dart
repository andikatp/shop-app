import 'package:flutter/material.dart' hide Badge;
import 'package:provider/provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/main_screen.dart';
import 'package:shop_app/screens/profile_screen.dart';
import 'package:shop_app/screens/qr_scan_screen.dart';
import 'package:shop_app/widgets/badge.dart';
import '../provider/cart.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({Key? key}) : super(key: key);
  static const routeName = '/bottom-navbar-screen';

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  final List<Widget> item = [
    const MainScreen(),
    const EditProductScreen(),
    const QrScanScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];
  int page = 0;

  void changePage(int value) {
    setState(() => page = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: changePage,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.edit_outlined,
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.document_scanner_outlined,
              color: Colors.black,
              size: 30,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Consumer<Cart>(
              builder: (_, value, ch) => Badge(
                value: value.itemCount.toString(),
                child: ch!,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
              ),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outlined,
            ),
            label: '',
          ),
        ],
        currentIndex: page,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
      body: item[page],
    );
  }
}
