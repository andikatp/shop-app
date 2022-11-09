import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/product_model.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItemWidget extends StatelessWidget {
  const ProductItemWidget({super.key});

  // const ProductItemWidget(
  //     {super.key,
  //     required this.id,
  //     required this.title,
  //     required this.imageUrl});
  // final String id;
  // final String title;
  // final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final providerProduct = Provider.of<ProductModel>(context, listen: false);
    final providerCart = Provider.of<Cart>(context, listen: false);
    final providerAuth = Provider.of<Auth>(context);
    String title = providerProduct.title;
    String id = providerProduct.id;
    String imageUrl = providerProduct.imageUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(title),
          leading: Consumer<ProductModel>(
            builder: (ctx, value, _) => IconButton(
              onPressed: () {
                providerProduct.toggleFavoriteStatus(
                  providerAuth.token ?? '',
                  providerAuth.userId ?? '',
                );
              },
              icon: Icon(
                providerProduct.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              providerCart.addItem(id, providerProduct.price, title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text(
                  'Item added to the cart!',
                ),
                duration: const Duration(seconds: 1),
                action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      providerCart.removeSingleItem(id);
                    }),
              ));
            },
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
              return SizedBox(
                height: 400,
                width: double.infinity,
                child: Text(error.toString()),
              );
            },
          ),
        ),
      ),
    );
  }
}
