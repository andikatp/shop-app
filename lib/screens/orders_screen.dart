import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/orders.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  static const routeName = '/Order-Screen';

  // final bool _isLoading = false;

  //   void initState() {
  //   // Future.delayed(Duration.zero).then((value) async {
  //   //   setState(() {
  //   //     _isLoading = true;
  //   //   });
  //   //   await Provider.of<Orders>(context, listen: false).fetchAndSet();
  //   //   setState(() {
  //   //     _isLoading = false;
  //   //   });
  //   // });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSet(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            //error handling
            return const Center(child: Text('An error has occured'));
          } else {
            return Consumer<Orders>(
              builder: (context, value, child) {
                return ListView.builder(
                  itemCount: value.orders.length,
                  itemBuilder: (context, index) {
                    return OrderItem(
                      order: value.orders[index],
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
