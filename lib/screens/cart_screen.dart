import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/orders.dart';
import 'package:shop_app/widgets/cart_item_widget.dart';
import '../provider/cart.dart' show Cart;

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  static const routeName = '/Cart-Screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final itemCart = cart.items.values.toList();
    final itemId = cart.items.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrder(
                          cart.items.values.toList(), cart.totalAmount);
                      cart.clear();
                    },
                    child: Text(
                      'Order Now',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return CartItemWidget(
                    id: itemCart[index].id,
                    productId: itemId[index],
                    title: itemCart[index].title,
                    price: itemCart[index].price,
                    quantity: itemCart[index].quantity);
              },
              itemCount: cart.itemCount,
            ),
          )
        ],
      ),
    );
  }
}
