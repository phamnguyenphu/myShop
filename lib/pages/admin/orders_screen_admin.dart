import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/pages/admin/ordertabs/cancelled_tab.dart';
import 'package:myshop/pages/admin/ordertabs/delivered_tab.dart';
import 'package:myshop/pages/admin/ordertabs/delivering_tab.dart';
import 'package:myshop/pages/admin/ordertabs/ordered_tab.dart';

class OrdersScreenAdmin extends StatelessWidget {
  const OrdersScreenAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Orders"),
          bottom: const TabBar(
            isScrollable: true,
            indicatorWeight: 6,
            automaticIndicatorColorAdjustment: true,
            labelColor: Palette.primaryMaterialColor,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                icon: Icon(EvaIcons.shoppingCartOutline),
                text: "Ordered",
              ),
              Tab(
                icon: Icon(EvaIcons.carOutline),
                text: "Delivering",
              ),
              Tab(
                icon: Icon(EvaIcons.giftOutline),
                text: "Delivered",
              ),
              Tab(
                icon: Icon(EvaIcons.close),
                text: "Cancelled",
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            OrderedTab(),
            DeliveringTab(),
            DeliveredTab(),
            CancelledTab(),
          ],
        ),
      ),
    );
  }
}
