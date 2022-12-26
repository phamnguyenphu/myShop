import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/components/empty.dart';
import 'package:myshop/components/product_card.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/helpers/product.dart';
import 'package:myshop/pages/product_view_screen.dart';

import '../helpers/category.dart';
import 'category_products_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  HomeTabState createState() => HomeTabState();
}

class HomeTabState extends State<HomeTab> {
  bool _isLoading = false;
  bool _isEmpty = false;

  List<QueryDocumentSnapshot> products = [];
  List<DocumentSnapshot> categories = [];
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
    QuerySnapshot qSnapCate = await getCategories();
    if (qsnap.size > 0 && qSnapCate.size > 0) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isEmpty = false;
          products = qsnap.docs;
          categories = qSnapCate.docs;
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

  final List<String> imgList = [
    'https://img.pikbest.com/origin/05/84/47/30DpIkbEsTXtA.jpg!w700wp',
    'https://cdn.shopify.com/s/files/1/0817/8783/files/raw-roasted.png?v=1613668002',
    'https://previews.123rf.com/images/makc76/makc761801/makc76180100216/94356558-summer-fruit-banner-with-a-discount-bright-juice-background-for-discount-offers.jpg',
    'https://img.freepik.com/premium-psd/fresh-milk-product-sale-social-media-banner-instagram-post-design-template_237357-201.jpg?w=2000',
    'https://assets1.chainstoreage.com/styles/primary_articles_short/s3/2019-11/Produce_fresh_veggies_0.jpg?itok=2YEI5kQ4',
    'https://thumbs.dreamstime.com/b/special-offer-christmas-sale-up-to-off-red-discount-banner-garland-present-cookies-glass-milk-santa-special-192341968.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item, fit: BoxFit.cover, width: 1000.0),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();
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
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    initialPage: 2,
                    autoPlay: false,
                  ),
                  items: imageSliders,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Category",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/shop_by_category");
                      },
                      child: const Text(
                        "See More",
                        style: TextStyle(color: Color(0xFFBBBBBB)),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12.0),
                  alignment: Alignment.centerLeft,
                  height: 100,
                  child: GridView.count(
                    childAspectRatio: 0.4,
                    shrinkWrap: true,
                    crossAxisCount: 1,
                    mainAxisSpacing: 15,
                    scrollDirection: Axis.horizontal,
                    children: categories.map((category) {
                      Map<String, dynamic> cate =
                          category.data() as Map<String, dynamic>;
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CategoryProductsScreen(category: category),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Stack(children: [
                            Container(
                              //margin: const EdgeInsets.all(5),
                              // padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(cate["url"])),
                                color: accentColor,
                                //borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF343434).withOpacity(0.7),
                                    const Color(0xFF343434).withOpacity(0.4)
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  category.id,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Featured Products",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/all_product");
                      },
                      child: const Text(
                        "See More",
                        style: TextStyle(color: Color(0xFFBBBBBB)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Expanded(
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
                ),
              ],
            ),
          ),
        );
      }
    }
  }
}
