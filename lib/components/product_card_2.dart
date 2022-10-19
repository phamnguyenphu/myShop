import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/config/currency.dart';
import 'package:shimmer/shimmer.dart';

class ProductCard2 extends StatelessWidget {
  final QueryDocumentSnapshot product;
  final Function onTap;
  final Function onAddToCartTap;
  const ProductCard2({
    required this.product,
    required this.onTap,
    required this.onAddToCartTap,
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
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: AspectRatio(
                    aspectRatio: 9 / 14,
                    child: CachedNetworkImage(
                      imageUrl: productData!["productImage"],
                      placeholder: (c, s) =>
                          Image.asset("assets/placeholder.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productData["productName"],
                          softWrap: true,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
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
                        const SizedBox(
                          height: 5,
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
                    IconButton(
                      color: primaryColor,
                      onPressed: () {
                        onAddToCartTap();
                      },
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        size: 34,
                      ),
                    ),
                  ],
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
