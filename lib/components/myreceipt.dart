// import 'package:flutter/material.dart';
// import 'package:food_delivery_app/model/restaurant.dart';
// import 'package:provider/provider.dart';
//
// class MyReceipt extends StatelessWidget {
//   const MyReceipt({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(left: 25, right: 25, bottom: 25, top: 50),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Thankyou for your order"),
//             SizedBox(
//               height: 25,
//             ),
//             Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(
//                       color: Theme.of(context).colorScheme.secondary)),
//               padding: EdgeInsets.all(25),
//               child: Consumer<Restaurant>(
//                 builder: (context, restaurant, child) =>
//                     Text(restaurant.displayCartInfo()),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Text("Estimated delivery time :4:10"),
//           ],
//         ),
//       ),
//     );
//   }
// }
