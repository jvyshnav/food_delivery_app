import 'food.dart';

class CartItem {
  final Food food;
  final List<Addon> selectedAddons;
  int _quantity; // Made private

  CartItem({
    required this.food,
    required this.selectedAddons,
    int quantity = 1, // Add quantity as parameter to constructor
  }) : _quantity = quantity; // Initialize _quantity in constructor

  int get quantity => _quantity; // Getter method

  void incrementQuantity() {
    _quantity++;
  }

  void decrementQuantity() {
    if (_quantity > 1) {
      _quantity--;
    }
  }
}