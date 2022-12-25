import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/config/currency.dart';
import 'package:myshop/helpers/cart.dart';
import 'package:myshop/pages/product_image_viewer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:status_alert/status_alert.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProductViewScreen extends StatelessWidget {
  final DocumentSnapshot document;

  const ProductViewScreen({required this.document, Key? key}) : super(key: key);

  void _showAlertAddProduct(
      BuildContext context, String title, IconData iconData) {
    StatusAlert.show(context,
        title: title,
        subtitle: "Go to cart for checkout",
        configuration: IconConfiguration(icon: iconData),
        duration: const Duration(seconds: 1));
  }

  _addProductToCartBtnTap(context) async {
    var checkProduct = await addProductToCart(
        document.id, document.data() as Map<String, dynamic>, 1);
    if (checkProduct) {
      _showAlertAddProduct(context, "Added to Cart", Icons.done);
    } else {
      _showAlertAddProduct(context, "Plus one unit", Icons.add);
    }
    // StatusAlert.show(
    //   context,
    //   title: "Added to Cart",
    //   subtitle: "Go to cart for checkout",
    //   configuration: const IconConfiguration(icon: Icons.done),
    //   duration: const Duration(seconds: 4),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Map<String, dynamic>? product = document.data() as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: Text(product!["productName"]),
        actions: const [],
      ),
      body: SizedBox(
        width: width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Center(
                    child: Hero(
                      tag: product["productImage"],
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: product["productImage"],
                          placeholder: (c, s) =>
                              Image.asset("assets/placeholder.png"),
                          height: width * .9,
                          width: width * .9,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 30,
                    bottom: 10,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductImageViewer(
                              imageUrl: product["productImage"],
                              title: product["productName"],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Palette.primaryMaterialColor.withOpacity(.7),
                        ),
                        child: const Icon(
                          Icons.fullscreen_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  if (product["isFeatured"] == true) ...[
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Shimmer.fromColors(
                          baseColor: Colors.white,
                          highlightColor: primaryColor,
                          child: Row(
                            children: const [
                              Icon(
                                Icons.star,
                                color: Colors.white,
                              ),
                              Text("Featured"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              // product
              const SizedBox(
                height: 20,
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      product["productName"],
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "$currencySymbol${product['salePrice'].toString()}",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.green[600],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (product["price"] != product["salePrice"]) ...[
                          Text(
                            product["price"].toString(),
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.grey[700],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ]
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _addProductToCartBtnTap(context);
                      },
                      child: const Text("Add to cart"),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      "About Product",
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      product["description"],
                      softWrap: true,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DataTable(columns: const [
                      DataColumn(label: Text("Details")),
                      DataColumn(label: Text("")),
                    ], rows: [
                      DataRow(
                        cells: [
                          const DataCell(Text("Added")),
                          DataCell(Text(
                              timeago.format(product["created_at"].toDate()))),
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(Text("Last Updated on")),
                          DataCell(Text(
                              timeago.format(product["updated_at"].toDate()))),
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(Text("Category")),
                          DataCell(Text(product["category"])),
                        ],
                      ),
                    ])
                  ],
                ),
              ),

              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
