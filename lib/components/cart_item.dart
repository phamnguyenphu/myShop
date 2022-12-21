import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myshop/config/currency.dart';

class CartItem extends StatefulWidget {
  final dynamic product;
  final Function onDeleteTap;

  const CartItem({Key? key, @required this.product, required this.onDeleteTap})
      : super(key: key);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  int count = 1;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                placeholder: (c, s) => Image.asset("assets/placeholder.png"),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                imageUrl: widget.product["productImage"],
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
                    widget.product["productName"],
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "$currencySymbol${widget.product['salePrice'].toString()}",
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green[600],
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      if (widget.product["price"] !=
                          widget.product["salePrice"]) ...[
                        Text(
                          widget.product["price"].toString(),
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.grey[700],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.5))),
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                FontAwesomeIcons.minus,
                                size: 10,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              onPressed: () {
                                setState(() {
                                  count--;
                                });
                              },
                            ),
                            // child: InkWell(
                            //   onTap: () {
                            //     setState(() {
                            //       count--;
                            //     });
                            //   },
                            //   child: Icon(
                            //     FontAwesomeIcons.minus,
                            //     size: 10,
                            //     color: Colors.black.withOpacity(0.5),
                            //   ),
                            // ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("$count"),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.5))),
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                FontAwesomeIcons.plus,
                                size: 10,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              onPressed: () {
                                setState(() {
                                  count++;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                widget.onDeleteTap();
              },
              color: Colors.red,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
