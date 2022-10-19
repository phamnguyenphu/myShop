import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/components/cart_item.dart';
import 'package:myshop/components/empty.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/helpers/cart.dart';
import 'package:myshop/pages/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  bool _isEmpty = false;
  bool _isLoading = true;
  List cart = [];

  @override
  void initState() {
    super.initState();
    loadProductsFromCart();
  }

  loadProductsFromCart() async {
    setState(() {
      _isLoading = true;
    });

    dynamic c = await getCart();
    if (c != null && c.length > 0) {
      setState(() {
        cart = c;
        _isEmpty = false;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isEmpty = true;
        _isLoading = false;
      });
    }
  }

  btnOnDeleteCartItemTap(index) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text("Are you sure?"),
          content:
              const Text("You are going to remove the product from your cart."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              style: ButtonStyle(
                textStyle: MaterialStateProperty.resolveWith(
                    (states) => const TextStyle(color: Colors.red)),
              ),
              onPressed: () async {
                await deleteProductFromCart(index);

                await loadProductsFromCart();
                if (!mounted) return;
                Navigator.pop(ctx);
              },
              child: const Text("Yes, Delete it"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: _isLoading == true
          ? const Center(
              child: SpinKitChasingDots(
                color: primaryColor,
                size: 50,
              ),
            )
          : _isEmpty == true
              ? const Empty(text: "No products in your cart!")
              : Column(
                  children: [
                    Flexible(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          return loadProductsFromCart();
                        },
                        child: ListView.separated(
                          itemBuilder: (ctx, i) {
                            return CartItem(
                              product: cart[i],
                              onDeleteTap: () {
                                btnOnDeleteCartItemTap(i);
                              },
                            );
                          },
                          separatorBuilder: (ctx, i) => const Divider(),
                          itemCount: cart.length,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 30,
                            color: Color(0x44000000),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutScreen(
                                cart: cart,
                              ),
                            ),
                          );
                        },
                        child: const Text("Proceed to checkout"),
                      ),
                    ),
                  ],
                ),
    );
  }
}
