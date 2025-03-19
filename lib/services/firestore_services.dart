import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/food.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get food items for a specific category
  Stream<List<Food>> getFoodItems(FoodCategory category) {
    try {
      return _firestore
          .collection('categories')
          .doc(category.name)
          .collection('foods') // Match the collection name used in AddFoodScreen
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          // Pass both the map data and the document ID
          return Food.fromMap(doc.data(), doc.id);
        }).toList();
      });
    } catch (e) {
      print('Error getting food items: $e');
      // Return empty list on error
      return Stream.value([]);
    }
  }

  // Get a single food item
  Future<Food?> getFoodItem(String categoryName, String foodId) async {
    try {
      final doc = await _firestore
          .collection('categories')
          .doc(categoryName)
          .collection('foods')
          .doc(foodId)
          .get();

      if (doc.exists) {
        return Food.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting food item: $e');
      return null;
    }
  }

  // Delete a food item
  Future<void> deleteFoodItem(String categoryName, String foodId) async {
    try {
      await _firestore
          .collection('categories')
          .doc(categoryName)
          .collection('foods')
          .doc(foodId)
          .delete();
    } catch (e) {
      print('Error deleting food item: $e');
      throw e;
    }
  }

  // Get a single food document (for addon fetching)
  Future<DocumentSnapshot<Map<String, dynamic>>> getFoodDocument(
      String categoryName, String foodId) async {
    try {
      return _firestore
          .collection('categories')
          .doc(categoryName)
          .collection('foods')
          .doc(foodId)
          .get();
    } catch (e) {
      print('Error getting food document: $e');
      throw e;
    }
  }
}