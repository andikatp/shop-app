import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/provider/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});
  static const routeName = '/product-detail-screen';

  @override
  Widget build(BuildContext context) {
    final String productId = ModalRoute.of(context)?.settings.arguments as String;
    final ProductsProvider provider = Provider.of<ProductsProvider>(context);
    final ProductModel loadedProduct = provider.findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
    );
  }
}
