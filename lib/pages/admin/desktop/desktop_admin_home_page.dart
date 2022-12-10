import 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myshop/config/image_upload.dart';
import 'package:myshop/helpers/order.dart';
import 'package:myshop/helpers/product.dart';

import '../../../components/admin_home_grid_item.dart';
import '../../../config/colors.dart';
import '../../../config/strings.dart';
import '../../../helpers/auth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../helpers/category.dart';

class DesktopAdminHomeScreen extends StatelessWidget {
  const DesktopAdminHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 300,
              child: Drawer(
                child: ListView(
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text(
                          FirebaseAuth.instance.currentUser!.displayName ?? ""),
                      accountEmail:
                          Text(FirebaseAuth.instance.currentUser!.email ?? ""),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            FirebaseAuth.instance.currentUser!.photoURL ?? "https://w7.pngwing.com/pngs/831/88/png-transparent-user-profile-computer-icons-user-interface-mystique-miscellaneous-user-interface-design-smile-thumbnail.png"),
                      ),
                      decoration: const BoxDecoration(
                        color: primaryColor,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, "/home");
                      },
                      title: const Text("Goto to Buyer Mode"),
                      leading: const Icon(EvaIcons.shoppingCartOutline),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, "/manage_products");
                      },
                      title: const Text("Manage Products"),
                      leading: const Icon(EvaIcons.briefcase),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, "/categories_admin");
                      },
                      title: const Text("Manage Categories"),
                      leading: const Icon(EvaIcons.grid),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, "/admin_orders");
                      },
                      title: const Text("Manage Orders"),
                      leading: const Icon(EvaIcons.browser),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, "/user_details");
                      },
                      title: const Text("Manage Users"),
                      leading: const Icon(EvaIcons.person),
                    ),
                    ListTile(
                      onTap: () {
                        signOut().then((e) {
                          Navigator.pushReplacementNamed(context, "/");
                        }).catchError((e) {
                          debugPrint(e.toString());
                        });
                      },
                      title: const Text("Logout"),
                      leading: const Icon(EvaIcons.logOutOutline),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: DashboardScreen(),
            )
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<DataChart> _chartData = [];
  List<DataCircularChart> _chartDataCircular = [];
  List<String> _categoryName = [];
  int ordered = 0;
  int delivering = 0;
  int delivered = 0;
  int cancelled = 0;

  @override
  void initState() {
    getCategoryChart();
    getBillOrderCount();
    // TODO: implement initState
    super.initState();
    //billOrderCount = getBillOrderCount();
  }

  getBillOrderCount() async {
    try {
      QuerySnapshot qSnapOrdered = await getOrders("ordered");
      QuerySnapshot qSnapDelivering = await getOrders("delivering");
      QuerySnapshot qSnapDeliverd = await getOrders("delivered");
      QuerySnapshot qSnapCancelled = await getOrders("cancelled");
      if (qSnapOrdered.size > 0 ||
          qSnapDelivering.size > 0 ||
          qSnapDeliverd.size > 0 ||
          qSnapCancelled.size > 0) {
        //print(qSnap.size);
        setState(() {
          ordered = qSnapOrdered.size;
          delivering = qSnapDelivering.size;
          delivered = qSnapDeliverd.size;
          cancelled = qSnapCancelled.size;
          _chartData = [
            DataChart(statusOrders: "Ordered", countOrder: ordered),
            DataChart(statusOrders: "Delivering", countOrder: delivering),
            DataChart(statusOrders: "Delivered", countOrder: delivered),
            DataChart(statusOrders: "Cancelled", countOrder: cancelled),
          ];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  getCategoryChart() async {
    try {
      QuerySnapshot qSnapCategory = await getCategories();
      if (qSnapCategory.size > 0) {
        List<DocumentSnapshot> categoryList = qSnapCategory.docs;
        for (var i in categoryList) {
          Map<String, dynamic> dataCategory = i.data() as Map<String, dynamic>;
          _categoryName.add(dataCategory['title']);
        }
        if (_categoryName.isNotEmpty) {
          for (var i in _categoryName) {
            QuerySnapshot qSnap = await getProductsByCategory(i);
            setState(() {
              _chartDataCircular.add(DataCircularChart(
                  categoryProducts: i, countProduct: qSnap.size));
            });
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              height: 60,
            ),
            Text("Dashboard", style: Theme.of(context).textTheme.headline6),
            const SizedBox(
              height: 40,
            ),
            Text("My Manager", style: Theme.of(context).textTheme.subtitle1),
            const SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              //width: double.infinity,
              height: 200,
              child: GridView.count(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                crossAxisCount: 1,
                mainAxisSpacing: 5,
                children: [
                  AdminHomeGridItem(
                    icon: Icons.category,
                    text: "Products",
                    onTap: () {
                      Navigator.pushNamed(context, "/manage_products");
                    },
                    iconColor: Colors.blue,
                  ),
                  AdminHomeGridItem(
                    icon: Icons.local_offer,
                    text: "Categories",
                    onTap: () {
                      Navigator.pushNamed(context, "/categories_admin");
                    },
                    iconColor: Colors.deepOrangeAccent,
                  ),
                  AdminHomeGridItem(
                    icon: Icons.local_shipping,
                    text: "Orders",
                    onTap: () {
                      Navigator.pushNamed(context, "/admin_orders");
                    },
                  ),
                  AdminHomeGridItem(
                    icon: Icons.people,
                    text: "Users",
                    onTap: () {
                      Navigator.pushNamed(context, "/user_details");
                    },
                    iconColor: Colors.brown,
                  ),
                  AdminHomeGridItem(
                    icon: Icons.storefront,
                    text: "Shop Details",
                    onTap: () {
                      Navigator.pushNamed(context, "/edit_shop_details");
                    },
                    iconColor: Colors.deepPurple,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Text("My Chart", style: Theme.of(context).textTheme.subtitle1),
            const SizedBox(
              height: 20,
            ),
            SfCartesianChart(
              legend: Legend(isVisible: true),
              series: <ChartSeries>[
                BarSeries<DataChart, String>(
                    dataSource: _chartData,
                    xValueMapper: (DataChart data, _) => data.statusOrders,
                    yValueMapper: (DataChart data, _) => data.countOrder,
                    //dataLabelSettings: const DataLabelSettings(isVisible: true),
                    name: "Bill")
              ],
              primaryXAxis: CategoryAxis(
                  isVisible: true, title: AxisTitle(text: "Status")),
              primaryYAxis: NumericAxis(title: AxisTitle(text: "Orders")),
              title: ChartTitle(text: "Status Orders"),
            ),
            const SizedBox(
              height: 40,
            ),
            SfCircularChart(
              title: ChartTitle(text: "Amount Products of Category"),
              series: <CircularSeries>[
                // RadialBarSeries<DataCircularChart, String>(
                //     xValueMapper: (DataCircularChart data, _) => data.categoryProducts,
                //     yValueMapper: (DataCircularChart data, _) => data.countProduct)
                PieSeries<DataCircularChart, String>(
                  explode: true,
                  dataSource: _chartDataCircular,
                  xValueMapper: (DataCircularChart data, _) =>
                      data.categoryProducts,
                  yValueMapper: (DataCircularChart data, _) =>
                      data.countProduct,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                )
              ],
              legend: Legend(isVisible: true, alignment: ChartAlignment.center),
            ),
          ],
        ),
      ),
    );
  }
}

class DataChart {
  DataChart({required this.statusOrders, required this.countOrder});

  final String statusOrders;
  final int countOrder;
}

class DataCircularChart {
  DataCircularChart(
      {required this.categoryProducts, required this.countProduct});

  final String categoryProducts;
  final int countProduct;
}
