import 'package:flutter/material.dart';
import 'package:food_delivery_app/model/cart_item.dart';
import 'package:food_delivery_app/model/restaurant.dart';
import 'package:provider/provider.dart';
import 'payment_page.dart'; // Import your PaymentPage

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartItems = context.watch<Restaurant>().cart;
    final restaurant = context.read<Restaurant>();

    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: Image.network(
                    item.food.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ),
                  title: Text(item.food.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('\$${item.food.price} x ${item.quantity}'),
                      ...item.selectedAddons.map((addon) => Text(
                          '${addon.name}: \$${addon.price} x ${item.quantity}')),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          item.decrementQuantity();
                          if (item.quantity == 0) {
                            restaurant.removeFromCart(item);
                          }
                          restaurant.notifyListeners();
                        },
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          item.incrementQuantity();
                          restaurant.notifyListeners();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${context.watch<Restaurant>().getTotalPrice().toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  PaymentPage(),
                      ),
                    );
                  },
                  child: const Text('Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}