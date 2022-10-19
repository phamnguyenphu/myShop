import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/config/currency.dart';
import 'package:myshop/helpers/order.dart';
import 'package:myshop/helpers/user.dart';

class OrderDetailsScreenAdmin extends StatefulWidget {
  final DocumentSnapshot orderSnap;

  const OrderDetailsScreenAdmin({
    required this.orderSnap,
    Key? key,
  }) : super(key: key);

  @override
  OrderDetailsScreenAdminState createState() => OrderDetailsScreenAdminState();
}

class OrderDetailsScreenAdminState extends State<OrderDetailsScreenAdmin> {
  String orderStatus = '';
  bool _loading = true;
  Map<String, dynamic>? ouser;

  @override
  void initState() {
    Map<String, dynamic>? order =
        widget.orderSnap.data() as Map<String, dynamic>?;
    setState(() {
      orderStatus = order!['orderStatus'];
    });
    fetchUData();
    super.initState();
  }

  fetchUData() async {
    Map<String, dynamic>? order =
        widget.orderSnap.data() as Map<String, dynamic>?;

    DocumentSnapshot doc = await getUserDataById(order!['uid']);
    setState(() {
      ouser = doc.data() as Map<String, dynamic>?;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String id = widget.orderSnap.id;

    Map<String, dynamic>? order =
        widget.orderSnap.data() as Map<String, dynamic>?;

    DateTime createdAt = order!['created_at'].toDate();
    String formattedDate =
        "${createdAt.year}/${createdAt.month}/${createdAt.day} ${createdAt.hour}:${createdAt.minute}:${createdAt.second}";

    List<dynamic> cart = order['cart'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
      ),
      body: Column(
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order # $id",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
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
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${order['cart'].length} items",
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Column(
                        children: cart.map((c) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 5,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: c["productImage"],
                                    placeholder: (c, s) =>
                                        Image.asset("assets/placeholder.png"),
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 14,
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        c["productName"],
                                        softWrap: true,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "$currencySymbol${c['salePrice'].toString()}",
                                            softWrap: true,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.green[600],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          if (c["price"] != c["salePrice"]) ...[
                                            Text(
                                              c["price"].toString(),
                                              softWrap: true,
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            ),
                                          ]
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Cart Total",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "$currencySymbol${order['cartItemsTotal']}",
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Tax",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "$currencySymbol${order['taxAmount']} (${order['tax']}%)",
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Grant Total",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "$currencySymbol${order['total']}",
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("Customer Details"),
                    const SizedBox(
                      height: 10,
                    ),
                    if (_loading == false) ...[
                      DataTable(
                        columns: [
                          const DataColumn(label: Text("Name")),
                          DataColumn(label: Text(ouser!["displayName"] ?? '')),
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              const DataCell(Text("Payment Method")),
                              DataCell(Text(order["paymentMethod"]
                                  .toString()
                                  .toUpperCase())),
                            ],
                          ),
                          DataRow(
                            cells: [
                              const DataCell(Text("Payment Status")),
                              DataCell(Text(order["paymentStatus"]
                                  .toString()
                                  .toUpperCase())),
                            ],
                          ),
                          DataRow(
                            cells: [
                              const DataCell(Text("Address")),
                              DataCell(Text(order['address'] ?? '')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              const DataCell(Text("Address Type")),
                              DataCell(Text(order['addressType'] ?? '')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              const DataCell(Text("Phone")),
                              DataCell(Text(order['phone'] ?? '')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              const DataCell(Text("EMail")),
                              DataCell(Text(ouser!["email"] ?? '')),
                            ],
                          ),
                        ],
                      ),
                    ] else ...[
                      const Center(
                        child: SpinKitFadingCircle(
                          color: primaryColor,
                          size: 50,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Status Change, button
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 0,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 25,
            ),
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 18,
                  offset: Offset(0, 0),
                ),
              ],
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: DropdownButtonFormField(
                    value: orderStatus,
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: "Change Order Status",
                    ),
                    items: ['ordered', 'delivering', 'delivered', 'cancelled']
                        .map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (v) {
                      setState(() {
                        orderStatus = v.toString();
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  child: const Text("Save"),
                  onPressed: () async {
                    if (orderStatus != "") {
                      await updateOrderStatus(id, orderStatus);
                      await Future.delayed(const Duration(milliseconds: 300));
                      if (!mounted) return;
                      Navigator.pop(context, "done");
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
