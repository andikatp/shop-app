import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/provider/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  Orders(this.authToken, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://shop-app-b5606-default-rtdb.asia-southeast1.firebasedatabase.app/shop%20app/orders.json?auth=$authToken');
    final timeStamp = DateTime.now();
    try {
      http.Response response = await http.post(url,
          body: jsonEncode({
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': cartProducts
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'quantity': e.quantity,
                      'price': e.price,
                    })
                .toList(),
          }));
      _orders.insert(
        0,
        OrderItem(
          id: jsonDecode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchAndSet() async {
    final url = Uri.parse(
        'https://shop-app-b5606-default-rtdb.asia-southeast1.firebasedatabase.app/shop%20app/orders.json?auth=$authToken');
    final http.Response response = await http.get(url);
    List<OrderItem> loadedOrders = [];
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>?;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((key, value) {
      loadedOrders.add(
        OrderItem(
          id: key,
          amount: value['amount'],
          products: (value['products'] as List<dynamic>)
              .map(
                (e) => CartItem(
                  id: e['id'],
                  title: e['title'],
                  quantity: e['quantity'],
                  price: e['price'],
                ),
              )
              .toList(),
          dateTime: DateTime.parse(
            value['dateTime'],
          ),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
