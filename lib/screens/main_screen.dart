import 'package:flutter/material.dart' hide Badge;
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products_provider.dart';
import 'package:shop_app/screens/all_product.dart';
import 'package:shop_app/widgets/product_hori.dart';

enum FilterOption {
  favorite,
  all,
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const routeName = '/main-screen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isInit = true;
  bool _isLoading = false;
  final List<String> _items = [
    'Home',
    'Electronics',
    'Clothes',
    'Computers',
    'Handphones',
    'Foods'
  ];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchAndSetProduct().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  bool _isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  //top part
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 10, top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Discover',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                        const Spacer(),
                        PopupMenuButton(
                          padding: const EdgeInsets.all(0),
                          splashRadius: 5,
                          icon: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1.0,
                              ),
                            ),
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: Icon(
                                Icons.tune,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          onSelected: (FilterOption selectedValue) {
                            setState(
                              () {
                                if (selectedValue == FilterOption.favorite) {
                                  // provider.showFavOnly();
                                  _isFavorite = true;
                                } else {
                                  // provider.showAll();
                                  _isFavorite = false;
                                }
                              },
                            );
                          },
                          itemBuilder: (_) => [
                            const PopupMenuItem(
                              value: FilterOption.favorite,
                              child: Text('Only Favorite'),
                            ),
                            const PopupMenuItem(
                              value: FilterOption.all,
                              child: Text('Show All'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //below top part
                  SizedBox(
                    height: 70,
                    child: ListView(
                      padding: const EdgeInsets.only(left: 15),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: _items
                          .map(
                            (item) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Chip(
                                label: Text(item),
                                backgroundColor: item == 'Home'
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.shade200,
                                labelStyle: TextStyle(
                                    color: item == 'Home'
                                        ? Colors.white
                                        : Theme.of(context)
                                            .colorScheme
                                            .primary),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  //below category
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextField(
                          onTapOutside: (event) =>
                              FocusScope.of(context).unfocus(),
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 5),
                            prefixIcon: Icon(Icons.search_outlined,
                                color: Colors.grey.shade200),
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade200, width: 2),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(right: 15),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),
                        child: Icon(
                          Icons.menu,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ), 
                  //new product
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'New Product',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AllProduct(isFavorite: _isFavorite),
                            ),
                          ),
                          child: Text(
                            'See All',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 250,
                    child: ProductHori(_isFavorite),
                  ),
                  //below
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          'Special Offer For You',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      Container(
                        height: 100,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                              image: AssetImage('assets/1.jpg'),
                              fit: BoxFit.cover),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                '5% Discount',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.grey),
                              ),
                              const Text(
                                'For a cozy furniture',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              SizedBox(
                                height: 20,
                                width: 80,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0)),
                                  child: const Text(
                                    'Learn More',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class ChipWidget extends StatelessWidget {
  const ChipWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
