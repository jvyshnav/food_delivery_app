import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery_app/components/my_button.dart';
import 'package:food_delivery_app/pages/cart_page.dart';
import '../model/cart_item.dart';
import '../model/food.dart';

class FoodPage extends StatefulWidget {
  final String foodId;
  final String category;

  const FoodPage({super.key, required this.foodId, required this.category});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final Map<Addon, bool> selectedAddons = {};
  List<Addon> availableAddons = [];
  bool _isLoading = true;
  Food? food;

  @override
  void initState() {
    super.initState();
    _fetchFoodData();
  }

  Future<void> _fetchFoodData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.category)
          .collection('foods')
          .doc(widget.foodId)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data()!;
        food = Food(
          id: snapshot.id,
          name: data['name'],
          description: data['description'],
          price: data['price'].toDouble(),
          imageUrl: data['imageUrl'],
          category: FoodCategory.values.byName(widget.category),
        );

        // Fetch addons
        if (data['availableAddons'] != null) { // Corrected line
          availableAddons = (data['availableAddons'] as List) // Corrected line
              .map((addonData) => Addon(
            name: addonData['name'],
            price: addonData['price'].toDouble(),
          ))
              .toList();
          for (var addon in availableAddons) {
            selectedAddons[addon] = false;
          }
        }
      } else {
        print("Document does not exist");
        food = null;
      }
    } catch (e) {
      print("Error fetching food data: $e");
      food = null;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> addToCart(Food food) async {
    final chosenAddons = selectedAddons.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    CartItem cartItem = CartItem(food: food, selectedAddons: chosenAddons);

    List<CartItem>? cartItems =
    ModalRoute.of(context)!.settings.arguments as List<CartItem>?;
    if (cartItems == null) {
      cartItems = [];
    }
    cartItems.add(cartItem);

    Navigator.pop(context, cartItems);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (food == null) {
      return const Scaffold(
        body: Center(child: Text('Food not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(food!.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(food!.imageUrl),
              const SizedBox(height: 16),
              Text(food!.name, ),
              const SizedBox(height: 8),
              Text('\$${food!.price.toStringAsFixed(2)}'),
              const SizedBox(height: 16),
              Text(food!.description),
              const SizedBox(height: 16),
              if (availableAddons.isNotEmpty) ...[
                Text('Add-ons',),
                for (var addon in availableAddons)
                  CheckboxListTile(
                    title: Text('${addon.name} (\$${addon.price.toStringAsFixed(2)})'),
                    value: selectedAddons[addon],
                    onChanged: (bool? value) {
                      setState(() {
                        selectedAddons[addon] = value!;
                      });
                    },
                  ),
              ],
              const SizedBox(height: 24),
              MyButton(
                text: 'Add to Cart',
                onTap: () => addToCart(food!),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 25, top: 25),
          padding: const EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () => Navigator.pop(context,
                ModalRoute.of(context)!.settings.arguments),
            icon: const Icon(Icons.arrow_back_ios, size: 20),
          ),
        ),
      ),
    );
  }
}