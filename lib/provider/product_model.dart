import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductModel with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final url = Uri.parse(
        'https://shop-app-b5606-default-rtdb.asia-southeast1.firebasedatabase.app/shop%20app/prods/$id.json');
    final bool oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final http.Response response = await http.patch(
        url,
        body: jsonEncode({
          'isFavorite': isFavorite,
        }),
      );
      if (response.statusCode != 200) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
