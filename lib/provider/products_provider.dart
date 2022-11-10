import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/provider/product_model.dart';

class ProductsProvider with ChangeNotifier {
  final String? authToken;
  final String? userId;
  ProductsProvider(this.authToken, this.userId, this._items);

  List<ProductModel> _items = [
    // ProductModel(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // ProductModel(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // ProductModel(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // ProductModel(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // bool _showFavOnly = false;

  List<ProductModel> get items {
    // if (_showFavOnly) {
    //   return _items.where((element) => element.isFavorite).toList();
    // }
    return [..._items];
  }

  List<ProductModel> get favItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  ProductModel findById(String id) {
    return items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url = Uri.parse(
        'https://shop-app-b5606-default-rtdb.asia-southeast1.firebasedatabase.app/shop%20app/prods.json?auth=$authToken&$filterString');
    try {
      http.Response response = await http.get(url);
      Map<String, dynamic>? data =
          jsonDecode(response.body) as Map<String, dynamic>?;
      if (data == null) {
        return;
      }
      final http.Response favoriteResponse = await http.get(Uri.parse(
          'https://shop-app-b5606-default-rtdb.asia-southeast1.firebasedatabase.app/shop%20app/userFavorite/$userId.json?auth=$authToken'));
      final favoriteData = json.decode(favoriteResponse.body);
      final List<ProductModel> loadedProduct = [];
      data.forEach((prodId, prodData) {
        loadedProduct.add(ProductModel(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false));
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(ProductModel product) async {
    final url = Uri.parse(
        'https://shop-app-b5606-default-rtdb.asia-southeast1.firebasedatabase.app/shop%20app/prods.json?auth=$authToken');
    // _items.add(value);
    try {
      var response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );
      final newProduct = ProductModel(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      // _items.insert(0, newProduct); // klo mau y pling terlama dibkin gni
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  // void showFavOnly() {
  //   _showFavOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavOnly = false;
  //   notifyListeners();
  // }

  Future<void> updateProduct(String id, ProductModel newProduct) async {
    final url = Uri.parse(
        'https://shop-app-b5606-default-rtdb.asia-southeast1.firebasedatabase.app/shop%20app/prods/$id.json?auth=$authToken');
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      try {
        await http.patch(url,
            body: jsonEncode({
              'title': newProduct.title,
              'description': newProduct.description,
              'imageUrl': newProduct.imageUrl,
              'price': newProduct.price,
            }));
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        rethrow;
      }
    } else {
      log('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://shop-app-b5606-default-rtdb.asia-southeast1.firebasedatabase.app/shop%20app/prods/$id.json?auth=$authToken');
    final int existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    ProductModel? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final http.Response response = await http.delete(url);
    if (response.statusCode != 200) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw const HttpException('Could not delete product!');
    }
    existingProduct = null;
  }
}
