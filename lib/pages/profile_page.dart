import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/food.dart';

class AddFoodScreen extends StatefulWidget {
  final FoodCategory initialCategory;

  const AddFoodScreen({Key? key, required this.initialCategory}) : super(key: key);

  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController addonNameController = TextEditingController();
  final TextEditingController addonPriceController = TextEditingController();

  late FoodCategory selectedCategory;
  List<Addon> addons = [];

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory;
  }

  void addAddon() {
    if (addonNameController.text.isNotEmpty && addonPriceController.text.isNotEmpty) {
      setState(() {
        addons.add(Addon(
          name: addonNameController.text,
          price: double.parse(addonPriceController.text),
        ));
      });
      addonNameController.clear();
      addonPriceController.clear();
    }
  }

  void removeAddon(int index) {
    setState(() {
      addons.removeAt(index);
    });
  }

  void saveFood() async {
    if (_formKey.currentState!.validate()) {
      try {
        String foodName = nameController.text.trim();

        // Create a unique ID for this food item
        String foodId = "${DateTime.now().millisecondsSinceEpoch}_${foodName.replaceAll(" ", "_").toLowerCase()}";

        Food food = Food(
          id: foodId,  // Set the food's ID
          name: foodName,
          description: descriptionController.text,
          imageUrl: imageUrlController.text,
          price: double.parse(priceController.text),
          category: selectedCategory,
          availableAddons: addons,
        );

        // Use the same ID for the Firestore document
        await FirebaseFirestore.instance
            .collection('categories')
            .doc(selectedCategory.name)
            .collection('foods')
            .doc(foodId)  // Use the same ID here
            .set(food.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Food Item Added Successfully!')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error adding food: $e')),
        );
        print('Error adding food: $e');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Food Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Food Name'),
                  validator: (value) => value!.isEmpty ? 'Enter a food name' : null,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextFormField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                  validator: (value) => value!.isEmpty ? 'Enter image URL' : null,
                ),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter price' : null,
                ),

                DropdownButtonFormField<FoodCategory>(
                  value: selectedCategory,
                  onChanged: (FoodCategory? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                  items: FoodCategory.values.map((FoodCategory category) {
                    return DropdownMenuItem<FoodCategory>(
                      value: category,
                      child: Text(category.name.toUpperCase()),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'Category'),
                ),

                const SizedBox(height: 10),
                const Text("Add Addons", style: TextStyle(fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: addonNameController,
                  decoration: const InputDecoration(labelText: 'Addon Name'),
                ),
                TextFormField(
                  controller: addonPriceController,
                  decoration: const InputDecoration(labelText: 'Addon Price'),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(onPressed: addAddon, child: const Text('Add Addon')),

                const SizedBox(height: 10),
                if (addons.isNotEmpty) ...[
                  const Text("Added Addons:", style: TextStyle(fontWeight: FontWeight.bold)),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: addons.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(addons[index].name),
                        subtitle: Text("₹${addons[index].price.toStringAsFixed(2)}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removeAddon(index),
                        ),
                      );
                    },
                  ),
                ],

                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: saveFood,
                  child: const Text('Save Food Item'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}