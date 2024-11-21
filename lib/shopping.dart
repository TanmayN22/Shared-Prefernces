import 'package:flutter/material.dart';
import 'package:flutter_application_1/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  List<String> items = ['Banana', 'Apple', 'Tomato', 'orange', 'onion', 'garlic', 'ginger', 'pineapple', 'capsicum', 'mango', 'grapes', 'watermelon'];
  List<String> cart = [];

  Future saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("cart", cart);
  }

  Future saveToCart() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cart = prefs.getStringList('cart') ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    saveToCart();
  }

  void _addToCart(String item) {
    setState(() {
      if (!cart.contains(item)) {
        cart.add(item);
        saveItems();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Shop'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(cart: cart),
                    ),
                  ).then((_) => saveToCart());
                },
                icon: const Icon(Icons.shopping_cart_outlined))
          ],
        ),
        body: ListView.builder(
          itemCount: items.length,
          shrinkWrap: false,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index]),
              trailing: ElevatedButton(onPressed: () => _addToCart(items[index]), child: const Text('Add to cart')),
            );
          },
        ));
  }
}
