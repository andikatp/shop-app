import 'package:flutter/material.dart';
import 'package:shop_app/widgets/product_grid.dart';

class AllProduct extends StatelessWidget {
  final bool isFavorite;
  const AllProduct({
    Key? key,
    required this.isFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.chevron_left),
              iconSize: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
            Expanded(
              child: ProductGrid(isFavorite),
            ),
          ],
        ),
      ),
    );
  }
}
