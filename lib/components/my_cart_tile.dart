import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/my_quantity_selector.dart';
import 'package:food_delivery_app/model/cart_item.dart';

class MyCartTile extends StatelessWidget {
  const MyCartTile({super.key, required this.cartItem});

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Food Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  cartItem.food.imageUrl,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 40),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),

              // Food Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.food.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '\$${cartItem.food.price}',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),

              // Quantity Selector
              QuantitySelector(
                quantity: cartItem.quantity,
                food: cartItem.food,
                onIncrement: () {
                  // Handle increment logic here (Firebase update)
                },
                onDecrement: () {
                  // Handle decrement logic here (Firebase update)
                },
              ),
            ],
          ),

          // Add-ons (Horizontally Scrollable)
          if (cartItem.selectedAddons.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              "Add-ons",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 30, // Ensuring proper height for horizontal scroll
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cartItem.selectedAddons.length,
                itemBuilder: (context, index) {
                  final addon = cartItem.selectedAddons[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    child: Row(
                      children: [
                        Text(
                          addon.name,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.inversePrimary,
                              fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "(\$${addon.price})",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
