import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth.dart';
import '../provider/cart.dart';
import '../provider/product_model.dart';
import '../screens/product_detail_screen.dart';

class ProductItemWidgetHori extends StatelessWidget {
  const ProductItemWidgetHori({super.key});

  @override
  Widget build(BuildContext context) {
    final providerProduct = Provider.of<ProductModel>(context, listen: false);
    final providerAuth = Provider.of<Auth>(context);
    final providerCart = Provider.of<Cart>(context, listen: false);
    String title = providerProduct.title;
    String id = providerProduct.id;
    String imageUrl = providerProduct.imageUrl;
    String price = providerProduct.price.toStringAsFixed(2);

    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            ProductDetailScreen.routeName,
            arguments: id,
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 170,
            width: 170,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        top: 13,
                      ),
                      child: Text(
                        '\$$price',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    Consumer<ProductModel>(
                      builder: (ctx, value, _) => IconButton(
                        onPressed: () {
                          providerProduct.toggleFavoriteStatus(
                            providerAuth.token ?? '',
                            providerAuth.userId ?? '',
                          );
                        },
                        splashRadius: 10,
                        icon: Icon(
                          providerProduct.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 170,
                  color: Colors.grey.shade300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      IconButton(
                        splashRadius: 5,
                        onPressed: () {
                          providerCart.addItem(
                              id, providerProduct.price, title);
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
                          Icons.shopping_cart_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
