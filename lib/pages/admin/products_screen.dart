import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/components/empty.dart';
import 'package:myshop/components/my_dialog.dart';
import 'package:myshop/components/product_card.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/helpers/product.dart';
import 'package:myshop/pages/admin/create_product_screen.dart';
import 'package:myshop/pages/admin/product_update_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  ProductsScreenState createState() => ProductsScreenState();
}

class ProductsScreenState extends State<ProductsScreen> {
  bool _isLoading = false;
  bool _isEmpty = false;
  late List<QueryDocumentSnapshot> products;
  late QueryDocumentSnapshot lastDocument;

  late ScrollController _scrollController;

  @override
  void initState() {
    loadProducts();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          debugPrint("loading more uploads");
          loadMoreProducts();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    QuerySnapshot qsnap = await getProducts();
    if (qsnap.size > 0) {
      setState(() {
        products = qsnap.docs;
        lastDocument = qsnap.docs.last;
        _isLoading = false;
        _isEmpty = false;
      });
    } else {
      setState(() {
        _isEmpty = true;
        _isLoading = false;
      });
    }
  }

  loadMoreProducts() async {
    QuerySnapshot qsnap = await getMoreProducts(lastDocument);
    if (qsnap.size > 0) {
      setState(() {
        products.addAll(qsnap.docs);
        lastDocument = qsnap.docs.last;
        _isLoading = false;
        _isEmpty = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Products"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          try {
            String result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => const CreateProductScreen(),
                fullscreenDialog: true,
              ),
            );

            if (result == "done") {
              loadProducts();
            } else if (result == "failed") {
              showMyDialog(
                context: context,
                title: "oops",
                description: "Something went wrong",
              );
            }
          } catch (e) {
            debugPrint(e.toString());
          }
        },
        label: const Text("Create product"),
        icon: const Icon(Icons.add),
      ),
      body: Container(
        child: _isLoading == true
            ? const Center(
                child: SpinKitChasingDots(
                  color: primaryColor,
                  size: 50,
                ),
              )
            : _isEmpty == true
                ? const Empty(text: "No products found! Add now...")
                : RefreshIndicator(
                    onRefresh: () async {
                      return loadProducts();
                    },
                    child: ListView.separated(
                      controller: _scrollController,
                      itemCount: products.length,
                      separatorBuilder: (ctx, i) {
                        return const Divider();
                      },
                      itemBuilder: (ctx, i) {
                        return ProductCard(
                          product: products[i],
                          onTap: () async {
                            String result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductUpdateScreen(
                                  document: products[i],
                                ),
                              ),
                            );
                            if (result == "done") {
                              loadProducts();
                            }
                          },
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
