import 'package:flutter/material.dart';
import 'package:food_delivery_app/pages/cart_page.dart';

class MySilverAppBar extends StatefulWidget {
  const MySilverAppBar({super.key, required this.child, required this.title});

  final Widget title;
  final Widget child;

  @override
  State<MySilverAppBar> createState() => _MySilverAppBarState();
}

class _MySilverAppBarState extends State<MySilverAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 380,
      collapsedHeight: 120,
      floating: false,
      pinned: true,
      actions: [
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  CartPage(),
                  ));
            },
            icon: const Icon(Icons.shopping_cart)),
      ],
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text("Sunset Dinner"),
      flexibleSpace: FlexibleSpaceBar(
        background: widget.child,
        title: widget.title,
        centerTitle: true,
        titlePadding: const EdgeInsets.only(left: 0, right: 0, top: 0),
        expandedTitleScale: 1,
      ),
    );
  }
}
