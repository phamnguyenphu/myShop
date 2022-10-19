import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myshop/components/my_dialog.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/config/currency.dart';
import 'package:myshop/helpers/category.dart';
import 'package:myshop/helpers/product.dart';

class ProductUpdateScreen extends StatefulWidget {
  final DocumentSnapshot document;

  const ProductUpdateScreen({required this.document, Key? key})
      : super(key: key);

  @override
  ProductUpdateScreenState createState() => ProductUpdateScreenState();
}

class ProductUpdateScreenState extends State<ProductUpdateScreen> {
  late List<QueryDocumentSnapshot> _categories;

  bool _loading = false;

  // product fields
  String category = '';
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  bool isFeatured = true;
  // product fields

  @override
  void dispose() {
    productNameController.dispose();
    priceController.dispose();
    salePriceController.dispose();
    productDescriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    loadCategories();
    Map<String, dynamic>? product =
        widget.document.data() as Map<String, dynamic>?;
    productNameController.text = product!["productName"];
    productDescriptionController.text = product["description"];
    priceController.text = product["price"].toString();
    salePriceController.text = product["salePrice"].toString();
    isFeatured = product["isFeatured"];
    super.initState();
  }

  loadCategories() async {
    try {
      setState(() {
        _loading = true;
      });

      QuerySnapshot qsnap = await getCategories();
      Map<String, dynamic>? product =
          widget.document.data() as Map<String, dynamic>?;
      setState(() {
        _categories = qsnap.docs;
        category = product!["category"];
        _loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  onUpdateProductBtnTap() async {
    try {
      String productName = productNameController.text;
      String description = productDescriptionController.text;

      if (productName.isNotEmpty &&
          priceController.text.isNotEmpty &&
          salePriceController.text.isNotEmpty) {
        double price = double.parse(priceController.text);
        double salePrice = double.parse(salePriceController.text);

        if (salePrice <= price) {
          setState(() {
            _loading = true;
          });
          debugPrint(
              "$productName \n $description \n $price $salePrice \n $category  $isFeatured");

          updateProduct(
            widget.document.id,
            productName,
            description,
            price,
            salePrice,
            category,
            isFeatured,
          ).then((v) {
            Navigator.pop(context, "done");
          }).catchError((e) {
            Navigator.pop(context, "failed");
            debugPrint(e.toString());
          });
        } else {
          showMyDialog(
            context: context,
            title: "oops",
            description: "Sale Price should not be more than Price.",
          );
        }
      } else {
        showMyDialog(
          context: context,
          title: "oops",
          description: "Please provide all details.",
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  onDeleteProductBtnTap() async {
    Map<String, dynamic>? product =
        widget.document.data() as Map<String, dynamic>?;

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text("Are you sure?"),
          content: const Text(
              "Once you press delete, we will delete it from our storage, this process is irreversible."),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(ctx);
              },
            ),
            TextButton(
              style: ButtonStyle(
                textStyle: MaterialStateProperty.resolveWith(
                    (states) => const TextStyle(color: Colors.red)),
              ),
              child: const Text("Delete Permanently"),
              onPressed: () {
                deleteProduct(widget.document.id, product!["productImage"])
                    .then((value) {
                  Navigator.pop(ctx);
                }).catchError((e) {
                  debugPrint(e.toString());
                  Navigator.pop(ctx);
                });
              },
            ),
          ],
        );
      },
    );
    if (!mounted) return;
    Navigator.pop(context, "done");
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? product =
        widget.document.data() as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              onDeleteProductBtnTap();
            },
          ),
        ],
      ),
      body: _loading == true
          ? const Center(
              child: SpinKitChasingDots(
                color: primaryColor,
                size: 50,
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CachedNetworkImage(
                      placeholder: (c, s) =>
                          Image.asset("assets/placeholder.png"),
                      imageUrl: product!["productImage"],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        filled: true,
                        labelText: "Product Name",
                      ),
                      maxLength: 120,
                      controller: productNameController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        filled: true,
                        labelText: "Description",
                      ),
                      maxLines: 6,
                      controller: productDescriptionController,
                      maxLength: 600,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        filled: true,
                        labelText: "Price",
                        prefixIcon: Icon(FontAwesomeIcons.moneyBill1),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      controller: priceController,
                    ),
                    const Text(
                      "Price in $currencySymbol $currencyCode",
                      textAlign: TextAlign.end,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        filled: true,
                        labelText: "Sale Price",
                        prefixIcon: Icon(FontAwesomeIcons.moneyBill1),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      controller: salePriceController,
                    ),
                    const Text(
                      "Price in $currencySymbol $currencyCode",
                      textAlign: TextAlign.end,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (_categories.isNotEmpty && _categories.isNotEmpty) ...[
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          labelText: "Category",
                        ),
                        items: _categories.map((c) {
                          return DropdownMenuItem(
                            value: c.id,
                            child: Text(c.id),
                          );
                        }).toList(),
                        value: category,
                        onChanged: (v) {
                          setState(() {
                            category = v.toString();
                          });
                        },
                      ),
                    ],
                    const SizedBox(
                      height: 20,
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Text("Featured?"),
                        Switch(
                          value: isFeatured,
                          onChanged: (v) {
                            setState(() {
                              isFeatured = v;
                            });
                          },
                        ),
                        TextButton(
                          onPressed: () {
                            showMyDialog(
                                context: context,
                                title: "Featured Product",
                                description:
                                    "Featured product is used to market your product, When you turn on Featured switch, your product will be displayed at top, with special look.");
                          },
                          child: const Text("What is Featured?"),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        onUpdateProductBtnTap();
                      },
                      child: const Text("SAVE"),
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
