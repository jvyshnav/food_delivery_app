import 'package:flutter/material.dart';
import 'package:food_delivery_app/model/restaurant.dart';
import 'package:provider/provider.dart';

import '../components/my_receipt.dart';
 // Import the MyReceipt widget (or use inline logic)

class DeliveryProgressPage extends StatelessWidget {
  const DeliveryProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurant = Provider.of<Restaurant>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery In Progress"),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: _buildBottomBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Display receipt using MyReceipt component
            MyReceipt(receiptText: restaurant.displayCartInfo()),

            // Add any other delivery progress related UI here
            // ... (e.g., map, delivery status, etc.)

            // Add the "Return to Home" button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home'); // Navigate to home
                },
                child: const Text("Return to Home"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle),
            child: IconButton(
                onPressed: () {
                  // Add profile navigation logic here
                },
                icon: const Icon(Icons.person)),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Mitch Koko",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
                Text(
                  "Driver",
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                )
              ],
            ),
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle),
                child: IconButton(
                  onPressed: () {
                    // Add message functionality here
                  },
                  icon: const Icon(Icons.message),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle),
                child: IconButton(
                  onPressed: () {
                    // Add call functionality here
                  },
                  icon: const Icon(Icons.call),
                  color: Colors.green,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}