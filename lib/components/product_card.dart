import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/config/currency.dart';
import 'package:shimmer/shimmer.dart';

class ProductCard extends StatelessWidget {
  final QueryDocumentSnapshot product;
  final Function onTap;

  const ProductCard({
    required this.product,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? productData = product.data() as Map<String, dynamic>?;

    return InkWell(
      onTap: () {
        onTap();
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: productData!["productImage"],
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: productData["productImage"],
                      placeholder: (c, s) =>
                          Image.asset("assets/placeholder.png"),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 14,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productData["productName"],
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "$currencySymbol${productData['salePrice'].toString()}",
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green[600],
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          if (productData["price"] !=
                              productData["salePrice"]) ...[
                            Text(
                              productData["price"].toString(),
                              softWrap: true,
                              style: TextStyle(
                                color: Colors.grey[700],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ]
                        ],
                      ),
                      Text(
                        productData["category"],
                        softWrap: true,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (productData["isFeatured"] == true) ...[
            Positioned(
              top: 5,
              left: 5,
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
    );
  }
}
