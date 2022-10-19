import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:myshop/config/currency.dart';

class OrderItem extends StatelessWidget {
  final DocumentSnapshot orderSnapshot;
  final Function onTap;

  const OrderItem({
    required this.orderSnapshot,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? order = orderSnapshot.data() as Map<String, dynamic>?;
    var id = orderSnapshot.id;

    DateTime createdAt = order!['created_at'].toDate();
    String formattedDate =
        "${createdAt.year}/${createdAt.month}/${createdAt.day} ${createdAt.hour}:${createdAt.minute}:${createdAt.second}";

    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey[100]!,
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order # $id",
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${order['cart'].length} items",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "$currencySymbol${order['total']}",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              formattedDate,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (order['orderStatus'] == "ordered") ...[
                  Row(
                    children: [
                      const Icon(
                        EvaIcons.shoppingCartOutline,
                        color: Colors.orange,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        order['orderStatus'],
                        style: const TextStyle(
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ] else if (order['orderStatus'] == "delivering") ...[
                  Row(
                    children: [
                      const Icon(
                        EvaIcons.carOutline,
                        color: Colors.blue,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        order['orderStatus'],
                        style: const TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ] else if (order['orderStatus'] == "delivered") ...[
                  Row(
                    children: [
                      const Icon(
                        EvaIcons.giftOutline,
                        color: Colors.green,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        order['orderStatus'],
                        style: const TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ] else if (order['orderStatus'] == "cancelled") ...[
                  Row(
                    children: [
                      const Icon(
                        EvaIcons.close,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        order['orderStatus'],
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
                OutlinedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.resolveWith(
                      (states) => const EdgeInsets.symmetric(
                        vertical: 5,
                      ),
                    ),
                    shape: MaterialStateProperty.resolveWith(
                      (states) => RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    textStyle: MaterialStateProperty.resolveWith(
                      (states) => const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  onPressed: () {
                    onTap();
                  },
                  child: const Text(
                    "Details",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
