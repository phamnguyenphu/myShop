import 'package:flutter/material.dart';
import 'package:myshop/config/colors.dart';

class OrderPlacedScreen extends StatelessWidget {
  final String orderId;
  final String orderMethod;
  const OrderPlacedScreen(
      {required this.orderId, required this.orderMethod, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Placed"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(orderMethod == "selfPickup"
                  ? "assets/woman_cycling.gif"
                  : "assets/woman_calm.gif"),
              height: 300,
              fit: BoxFit.contain,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Your Order Placed."),
            Text("Order ID: $orderId"),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              style: ButtonStyle(
                textStyle: MaterialStateProperty.resolveWith(
                    (states) => const TextStyle(color: primaryColor)),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Let's go, Check order screen for updates."),
            ),
          ],
        ),
      ),
    );
  }
}
