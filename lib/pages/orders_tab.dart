import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/components/empty.dart';
import 'package:myshop/components/order_item.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/helpers/order.dart';
import 'package:myshop/pages/order_details_screen.dart';

class OrdersTab extends StatefulWidget {
  const OrdersTab({Key? key}) : super(key: key);

  @override
  OrdersTabState createState() => OrdersTabState();
}

class OrdersTabState extends State<OrdersTab> {
  bool _loading = true;
  bool _empty = true;
  List<QueryDocumentSnapshot> orders = [];
  @override
  void initState() {
    super.initState();
    loadMyOrders();
  }

  loadMyOrders() async {
    try {
      QuerySnapshot qSnap = await getAllOrdersOfUser();
      if (qSnap.size > 0) {
        setState(() {
          orders = qSnap.docs;
          _empty = false;
          _loading = false;
        });
      } else {
        setState(() {
          _empty = true;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        _empty = true;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading == true) {
      return const SpinKitChasingDots(
        color: primaryColor,
        size: 50,
      );
    }
    if (_empty == true) {
      return const Empty(text: "No orders!");
    }
    return RefreshIndicator(
      onRefresh: () async {
        return loadMyOrders();
      },
      child: ListView.builder(
        itemBuilder: (ctx, int i) {
          QueryDocumentSnapshot order = orders[i];
          return OrderItem(
            orderSnapshot: order,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailsScreen(
                    order: order,
                  ),
                ),
              );
            },
          );
        },
        itemCount: orders.length,
      ),
    );
  }
}
