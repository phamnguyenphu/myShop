import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/components/empty.dart';
import 'package:myshop/components/product_card.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/helpers/product.dart';
import 'package:myshop/pages/product_view_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  HomeTabState createState() => HomeTabState();
}

class HomeTabState extends State<HomeTab> {
  bool _isLoading = false;
  bool _isEmpty = false;

  List<QueryDocumentSnapshot> products = [];
  late QueryDocumentSnapshot lastDocument;

  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    loadProducts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        debugPrint("loading more uploads");
        loadMoreProducts();
      }
    });
    _pageController.addListener(() {
      if (_pageController.position.pixels ==
          _pageController.position.maxScrollExtent) {
        debugPrint("loading more uploads");
        loadMoreProducts();
      }
    });
  }

  loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    QuerySnapshot qsnap = await getProducts();
    if (qsnap.size > 0) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isEmpty = false;
          products = qsnap.docs;
          lastDocument = qsnap.docs.last;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
        _isEmpty = true;
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
    if (_isLoading == true) {
      return const Center(
        child: SpinKitChasingDots(
          color: primaryColor,
          size: 50,
        ),
      );
    } else {
      if (_isEmpty == true) {
        return const Empty(text: "No products found!");
      } else {
        return RefreshIndicator(
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductViewScreen(
                        document: products[i],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      }
    }
  }
}
