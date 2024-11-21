import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  final List<String> cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<String> cart;

  @override
  void initState() {
    super.initState();
    cart = widget.cart;
  }

  Future<void> _removeFromCart(String item) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cart.remove(item);
    });
    await prefs.setStringList('cart', cart);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: cart.isEmpty
          ? const Center(
              child: Text('Your cart is empty!'),
            )
          : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(cart[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => _removeFromCart(cart[index]),
                  ),
                );
              },
            ),
    );
  }
}
