import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/my_description_box.dart';
import 'package:food_delivery_app/components/my_drawer.dart';
import 'package:food_delivery_app/components/my_food_tile.dart';
import 'package:food_delivery_app/components/my_silver_appbar.dart';
import 'package:food_delivery_app/components/my_tab_bar.dart';
import 'package:food_delivery_app/model/food.dart';
import 'package:food_delivery_app/model/restaurant.dart';
import 'package:food_delivery_app/pages/food_page.dart';
import 'package:food_delivery_app/pages/profile_page.dart';
import 'package:provider/provider.dart';
import '../components/my_current_location,dart.dart';
import '../model/cart_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: FoodCategory.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> _buildCategoryTabs(BuildContext context) {
    return FoodCategory.values.map((category) {
      return StreamBuilder<List<Food>>(
        stream: context.watch<Restaurant>().getFoodItems(category),
        builder: (context, snapshot) {
          print("StreamBuilder Snapshot State: ${snapshot.connectionState}");
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("StreamBuilder: Waiting for data...");
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print("StreamBuilder Error: ${snapshot.error}");
            return _buildErrorWidget(context, category, snapshot);
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print('StreamBuilder: Snapshot data is empty or null');
            return _buildNoDataWidget(context, category);
          }

          print("StreamBuilder: Data received - ${snapshot.data!.length} items");
          final foodItems = snapshot.data!;
          return ListView.builder(
            itemCount: foodItems.length,
            padding: const EdgeInsets.only(bottom: 80),
            itemBuilder: (context, index) {
              final food = foodItems[index];
              return MyFoodTile(
                food: food,
                onTap: () async {
                  final restaurant =
                  Provider.of<Restaurant>(context, listen: false);
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FoodPage(
                        foodId: food.id,
                        category: food.category.name, // Corrected line
                      ),
                      settings: RouteSettings(
                        arguments: restaurant.cart,
                      ),
                    ),
                  );
                  if (result != null && result is List<CartItem>) {
                    Provider.of<Restaurant>(context, listen: false)
                        .updateCart(result);
                  }
                },
              );
            },
          );
        },
      );
    }).toList();
  }

  Widget _buildErrorWidget(BuildContext context, FoodCategory category,
      AsyncSnapshot<List<Food>> snapshot) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error loading ${category.name}\n${snapshot.error}',
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {});
            },
            child: const Text('Retry'),
          )
        ],
      ),
    );
  }

  Widget _buildNoDataWidget(BuildContext context, FoodCategory category) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.no_food, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text('No ${category.name} available',
              style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            onPressed: () {
              setState(() {});
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      drawer: const MyDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          MySilverAppBar(
            title: MyTabBar(tabController: _tabController),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Divider(
                  color: Theme.of(context).colorScheme.secondary,
                  indent: 25,
                  endIndent: 25,
                ),
                const MyCurrentLocation(),
                const MyDescriptionBox(),
              ],
            ),
          )
        ],
        body: TabBarView(
          controller: _tabController,
          children: _buildCategoryTabs(context),
        ),
      ),

    );
  }
}