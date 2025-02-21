import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/my_description_box.dart';
import 'package:food_delivery_app/components/my_current_location,dart.dart';
import 'package:food_delivery_app/components/my_drawer.dart';
import 'package:food_delivery_app/components/my_silver_appbar.dart';
import 'package:food_delivery_app/components/my_tab_bar.dart';

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
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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

                  //mycurrentlocaton
                  MyCurrentLocation(),

                  //description box
                  MyDescriptionBox(),
                ],
              ))
        ],
        body: TabBarView(controller: _tabController,
          children: [
            ListView.builder(itemCount: 5,
              itemBuilder: (context, index) => Text("Hello"),
            ),  ListView.builder(itemCount: 5,
              itemBuilder: (context, index) => Text("flutter"),
            ),  ListView.builder(itemCount: 5,
              itemBuilder: (context, index) => Text("Dart"),
            ),
          ],
        ),
      ),
    );
  }
}
