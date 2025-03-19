import 'package:flutter/material.dart';
import 'package:food_delivery_app/model/food.dart';

class MyTabBar extends StatelessWidget {
  const MyTabBar({super.key, required this.tabController});

  final TabController tabController;

  // List<Tab> _buildCategoryTab() {
  //   return FoodCategory.values.map((category) {
  //     return Tab(text: category.toString().split('.').last,);
  //   },).toList();
  // }

  List<Tab> _buildCategoryTab() {
    return FoodCategory.values.map((category) {
      return Tab(text: category.name);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(controller: tabController, tabs:_buildCategoryTab());
  }
}
