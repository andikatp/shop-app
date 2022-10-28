import 'package:flutter/material.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItemWidget extends StatelessWidget {
  const ProductItemWidget(
      {super.key,
      required this.id,
      required this.title,
      required this.imageUrl});
  final String id;
  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(title),
          leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.favorite,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              ProductDetailScreen.routeName,
              arguments: id,
            );
          },
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Text(':( no Internet');
            },
          ),
        ),
      ),
    );
  }
}
