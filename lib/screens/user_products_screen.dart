import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({super.key});
  static const routeName = '/User-Product-Screen';

  Future<void> _refresh(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    // final product = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Product'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refresh(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refresh(context),
                    child: Consumer<ProductsProvider>(
                      builder: (context, product, child) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: ListView.separated(
                            separatorBuilder: (context, index) => const Divider(
                              height: 1,
                              thickness: 1,
                            ),
                            itemCount: product.items.length,
                            itemBuilder: (_, index) {
                              return UserProductItem(
                                id: product.items[index].id,
                                title: product.items[index].title,
                                imageUrl: product.items[index].imageUrl,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
