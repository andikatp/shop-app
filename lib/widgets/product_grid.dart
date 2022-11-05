import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products_provider.dart';
import 'package:shop_app/widgets/product_item_widget.dart';

class ProductGrid extends StatelessWidget {
  bool isFavorite;
  ProductGrid(this.isFavorite, {super.key});
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = isFavorite ? productsData.favItems : productsData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return ChangeNotifierProvider.value(
            value: products[index],
            // create: (context) => products[index],
            child: const ProductItemWidget(
                // id: products[index].id,
                // imageUrl: products[index].imageUrl,
                // title: products[index].title,
                ),
          );
        },
        itemCount: products.length);
  }
}
