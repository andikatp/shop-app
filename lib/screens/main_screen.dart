import 'package:flutter/material.dart';

import '../widgets/product_grid.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  static const routeName = '/main-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Shop'),
      ),
      body: ProductGrid(),
    );
  }
}

