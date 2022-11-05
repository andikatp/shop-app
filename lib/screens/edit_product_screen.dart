import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product_model.dart';
import 'package:shop_app/provider/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});
  static const routeName = '/Edit-Product-Screen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceNode = FocusNode();
  final _imageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _imageNode = FocusNode();
  ProductModel _editedProduct = ProductModel(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  bool _isInit = true;
  Map<String, String> _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void dispose() {
    _imageController;
    _priceNode;
    _imageNode;
    super.dispose();
    _imageNode.removeListener(() {
      _updateImageUrl();
    });
  }

  void _updateImageUrl() {
    if (!_imageNode.hasFocus) {
      if ((!_imageController.text.startsWith('http') &&
              !_imageController.text.startsWith('https')) ||
          (!_imageController.text.endsWith('.png') &&
              !_imageController.text.endsWith('.jpg') &&
              !_imageController.text.endsWith('.jpeg'))) {
        return;
      }

      setState(() {});
    }
  }

  @override
  void initState() {
    _imageNode.addListener(() {
      _updateImageUrl;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final productId = ModalRoute.of(context)!.settings.arguments as String;
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm() {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    _formKey.currentState?.save();
    if (ModalRoute.of(context)!.settings.arguments != null) {
      Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(_editedProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Your Product'),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save)),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              initialValue: _initValues['title'],
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_priceNode),
              onSaved: (newValue) {
                if (newValue != null) {
                  _editedProduct = ProductModel(
                    id: _editedProduct.id,
                    title: newValue,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please provide a value';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              focusNode: _priceNode,
              initialValue: _initValues['price'],
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              onSaved: (newValue) {
                if (newValue != null) {
                  _editedProduct = ProductModel(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    price: double.parse(newValue),
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please provide a value.';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid Number.';
                }
                if (double.parse(value) <= 0) {
                  return 'Please return a number greater than zero.';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              initialValue: _initValues['description'],
              onSaved: (newValue) {
                if (newValue != null) {
                  _editedProduct = ProductModel(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: newValue,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please provide a value';
                }
                if (value.length < 10) {
                  return 'Should be at least 10 characters long.';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8, right: 10),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  height: 100,
                  width: 100,
                  child: Center(
                    child: _imageController.text.isEmpty
                        ? const Text('Input your Url')
                        : FittedBox(
                            child: Image.network(
                              fit: BoxFit.cover,
                              _imageController.text,
                              width: 100,
                              height: 100,
                            ),
                          ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    focusNode: _imageNode,
                    decoration: const InputDecoration(
                      labelText: 'Image URL',
                    ),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    controller: _imageController,
                    onEditingComplete: () {
                      setState(() {});
                    },
                    onFieldSubmitted: (_) => _saveForm(),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an image url';
                      }
                      if (!value.startsWith('http') &&
                          !value.startsWith('https')) {
                        return 'Please enter a valid URL.';
                      }
                      if (!value.endsWith('.png') &&
                          !value.endsWith('.jpg') &&
                          !value.endsWith('.jpeg')) {
                        return 'Please enter a valid Image Url';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      if (newValue != null) {
                        _editedProduct = ProductModel(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: newValue,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
