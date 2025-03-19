import 'package:flutter/material.dart';

// Food categories enum
enum FoodCategory {
  burgers,
  chicken,
  pizza,
  desserts,
  drinks,
}

// Addon class for additional food options
class Addon {
  final String name;
  final double price;

  Addon({
    required this.name,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
    };
  }

  factory Addon.fromMap(Map<String, dynamic> map) {
    return Addon(
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
    );
  }
}

// Main Food class
class Food {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final FoodCategory category;
  final List<Addon> availableAddons; // All available addons
  final List<Addon> selectedAddons;  // User-selected addons

  Food({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
    this.availableAddons = const [],
    this.selectedAddons = const [], // Default empty list
  });

  // Convert object to Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'category': category.name,
      'availableAddons': availableAddons.map((addon) => addon.toMap()).toList(),
      'selectedAddons': selectedAddons.map((addon) => addon.toMap()).toList(),
    };
  }

  // Create object from Map
  factory Food.fromMap(Map<String, dynamic> map, String docId) {
    // Parse category string to enum
    FoodCategory parsedCategory;
    try {
      parsedCategory = FoodCategory.values.firstWhere(
            (category) => category.name == (map['category'] ?? 'burgers'),
      );
    } catch (e) {
      parsedCategory = FoodCategory.burgers; // Default if not found
    }

    // Parse available addons
    List<Addon> addons = [];
    if (map['availableAddons'] != null) {
      if (map['availableAddons'] is List) {
        addons = (map['availableAddons'] as List)
            .map((addonMap) => Addon.fromMap(addonMap))
            .toList();
      }
    }

    // Parse selected addons (optional, for cart usage)
    List<Addon> selectedAddons = [];
    if (map['selectedAddons'] != null) {
      if (map['selectedAddons'] is List) {
        selectedAddons = (map['selectedAddons'] as List)
            .map((addonMap) => Addon.fromMap(addonMap))
            .toList();
      }
    }

    return Food(
      id: docId,
      name: map['name'] ?? 'Unknown Food',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      category: parsedCategory,
      availableAddons: addons,
      selectedAddons: selectedAddons, // Include selected addons
    );
  }

  // Calculate total price including selected addons
  double get totalPrice {
    double addonTotal = selectedAddons.fold(0.0, (sum, addon) => sum + addon.price);
    return price + addonTotal;
  }
}
