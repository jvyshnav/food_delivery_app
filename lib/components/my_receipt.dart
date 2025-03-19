import 'package:flutter/material.dart';

class MyReceipt extends StatelessWidget {
  final String receiptText;

  const MyReceipt({super.key, required this.receiptText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(receiptText),
    );
  }
}