import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/model/cart_item.dart';
import 'package:food_delivery_app/model/food.dart';
import 'package:food_delivery_app/services/firestore_services.dart';
import 'package:intl/intl.dart';

class Restaurant extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<CartItem> _cart = [];

  List<CartItem> get cart => _cart;

  void updateCart(List<CartItem> newCart) {
    _cart = newCart;
    notifyListeners();
  }

  // Fetch food items from Firebase (Corrected to return Stream)
  Stream<List<Food>> getFoodItems(FoodCategory category) {
    print("Restaurant: Fetching food items for ${category.name}");
    return _firestoreService.getFoodItems(category);
  }

  // Fetch addons from Firebase
  Future<List<Addon>> getAddons(String foodId, String category) async {
    final doc = await _firestoreService.getFoodDocument(foodId, category);
    if (doc.exists && doc.data()?['availableAddons'] != null) {
      return (doc.data()!['availableAddons'] as List)
          .map((addonData) => Addon(
        name: addonData['name'],
        price: addonData['price'].toDouble(),
      ))
          .toList();
    }
    return [];
  }

  void addToCart(Food food, List<Addon> selectedAddons) {
    CartItem? cartItem = _cart.firstWhereOrNull(
          (item) {
        bool isSameFood = item.food == food;
        bool isSameAddons =
        const ListEquality().equals(item.selectedAddons, selectedAddons);
        return isSameFood && isSameAddons;
      },
    );
    if (cartItem != null) {
      cartItem.incrementQuantity();
    } else {
      _cart.add(CartItem(
        food: food,
        selectedAddons: selectedAddons,
      ));
    }
    notifyListeners();
  }

  void removeFromCart(CartItem cartItem) {
    int cartIndex = _cart.indexOf(cartItem);

    if (cartIndex != -1) {
      if (_cart[cartIndex].quantity > 1) {
        _cart[cartIndex].decrementQuantity();
        if(_cart[cartIndex].quantity == 0){
          _cart.removeAt(cartIndex);
        }
      } else {
        _cart.removeAt(cartIndex);
      }
    }
    notifyListeners();
  }

  double getTotalPrice() {
    double total = 0.0;
    for (CartItem cartItem in _cart) {
      double itemTotal = cartItem.food.price;

      for (Addon addon in cartItem.selectedAddons) {
        itemTotal += addon.price;
      }
      total += itemTotal * cartItem.quantity;
    }
    return total;
  }

  int getTotalItemCount() {
    int totalItemCount = 0;
    for (CartItem cartItem in _cart) {
      totalItemCount += cartItem.quantity;
    }
    return totalItemCount;
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  String displayCartInfo() {
    final receipt = StringBuffer();
    receipt.writeln("Here is Your Receipt");
    receipt.writeln();
    String formattedDate =
    DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    receipt.writeln(formattedDate);
    receipt.writeln();
    receipt.writeln("-----");

    for (final cartItem in _cart) {
      receipt.writeln(
          "${cartItem.quantity} x ${cartItem.food.name} = ${_formatPrice(cartItem.food.price)}");
      if (cartItem.selectedAddons.isNotEmpty) {
        receipt.writeln(" Add-ons: ${formatAddons(cartItem.selectedAddons)}");
      }
      receipt.writeln();
    }
    receipt.writeln("----------");
    receipt.writeln();
    receipt.writeln("Total Items : ${getTotalItemCount()}");
    receipt.writeln("Total Price : ${_formatPrice(getTotalPrice())}");

    return receipt.toString();
  }

  String _formatPrice(double price) {
    return "\$ ${price.toStringAsFixed(2)}";
  }

  String formatAddons(List<Addon> addons) {
    return addons
        .map(
          (addon) => "${addon.name} (${_formatPrice(addon.price)})",
    )
        .join(", ");
  }
}