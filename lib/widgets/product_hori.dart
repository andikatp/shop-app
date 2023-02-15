import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products_provider.dart';
import 'package:shop_app/widgets/product_item_widget_hori.dart';

class ProductHori extends StatelessWidget {
  final bool isFavorite;
  const ProductHori(this.isFavorite, {super.key});
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = isFavorite ? productsData.favItems : productsData.items;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20).copyWith(top: 0),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
          // ignore: prefer_const_constructors
          child: ProductItemWidgetHori(),
        );
      },
      itemCount: products.length,
    );
  }
}
