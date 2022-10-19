import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/config/strings.dart';
import 'package:myshop/helpers/shop.dart';

class AboutShopDetails extends StatelessWidget {
  const AboutShopDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About $appName"),
      ),
      body: FutureBuilder(
        future: getShopDetails(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var shop = snapshot.data;
            Map<String, dynamic>? shopData =
                shop!.data() as Map<String, dynamic>?;
            return SingleChildScrollView(
              child: Center(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("")),
                    DataColumn(label: Text("")),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        const DataCell(Text("Shop Name")),
                        DataCell(Text(shopData!["shopName"] ?? "")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text("Address")),
                        DataCell(Text(shopData["address"] ?? "")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text("Phone")),
                        DataCell(Text(shopData["phone"] ?? "")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text("EMail")),
                        DataCell(Text(shopData["email"] ?? "")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text("Tax ID")),
                        DataCell(Text(shopData["taxNumber"] ?? "")),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: SpinKitChasingDots(
              color: primaryColor,
              size: 50,
            ),
          );
        },
      ),
    );
  }
}
