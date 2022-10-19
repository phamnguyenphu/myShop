import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/components/empty.dart';
import 'package:myshop/components/order_item.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/helpers/order.dart';
import 'package:myshop/pages/admin/order_details_screen_admin.dart';

class CancelledTab extends StatefulWidget {
  const CancelledTab({Key? key}) : super(key: key);

  @override
  CancelledTabState createState() => CancelledTabState();
}

class CancelledTabState extends State<CancelledTab> {
  bool _loading = true;
  bool _empty = true;
  List<DocumentSnapshot> orders = [];
  DocumentSnapshot? lastDocument;

  ScrollController? _scrollController;

  String tab = 'cancelled';

  @override
  void initState() {
    super.initState();
    loadOrders();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.position.pixels ==
            _scrollController!.position.maxScrollExtent) {
          debugPrint("loading more orders");
          loadMoreOrders();
        }
      });
  }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  loadOrders() async {
    try {
      QuerySnapshot qSnap = await getOrders(tab);
      if (qSnap.size > 0) {
        setState(() {
          _empty = false;
          orders = qSnap.docs;
          lastDocument = qSnap.docs.last;
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

  loadMoreOrders() async {
    try {
      QuerySnapshot qSnap = await getMoreOrders(tab, lastDocument!);
      if (qSnap.size > 0) {
        setState(() {
          _empty = false;
          orders.addAll(qSnap.docs);
          lastDocument = qSnap.docs.last;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _loading == true
          ? const Center(
              child: SpinKitPulse(
                color: primaryColor,
                size: 50,
              ),
            )
          : _empty == true
              ? const Empty(
                  text: "No orders!",
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    return await loadOrders();
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: orders.length,
                    itemBuilder: (ctx, i) {
                      return OrderItem(
                        orderSnapshot: orders[i],
                        onTap: () async {
                          String result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailsScreenAdmin(
                                orderSnap: orders[i],
                              ),
                            ),
                          );
                          if (result == "done") {
                            await loadOrders();
                          }
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
