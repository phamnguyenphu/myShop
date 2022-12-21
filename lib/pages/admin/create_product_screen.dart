import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myshop/components/my_dialog.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/config/currency.dart';
import 'package:myshop/config/image_upload.dart';
import 'package:myshop/helpers/category.dart';
import 'package:myshop/helpers/product.dart';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({Key? key}) : super(key: key);

  @override
  CreateProductScreenState createState() => CreateProductScreenState();
}

enum ImagePickCategory { camera, phone }

class CreateProductScreenState extends State<CreateProductScreen> {
  File? _productImage;

  List<QueryDocumentSnapshot>? _categories;

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
    super.initState();
  }

  loadCategories() async {
    try {
      setState(() {
        _loading = true;
      });

      QuerySnapshot qsnap = await getCategories();
      setState(() {
        _categories = qsnap.docs;
        category = qsnap.docs[0].id;
        _loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  onCreateProductBtnTap() async {
    try {
      String productName = productNameController.text;
      String description = productDescriptionController.text;

      if (productName.isNotEmpty &&
          priceController.text.isNotEmpty &&
          salePriceController.text.isNotEmpty &&
          _productImage != null &&
          _productImage!.path != "") {
        String productImageName = path.basename(_productImage!.path);
        double price = double.parse(priceController.text);
        double salePrice = double.parse(salePriceController.text);

        if (salePrice <= price) {
          // showMyLoadingModal(
          //   context,
          //   "Please wait...",
          // );
          setState(() {
            _loading = true;
          });
          debugPrint(
              "$productName \n $description \n $price $salePrice $productImageName \n $category  $isFeatured");

          uploadProductImage(
            productImageName,
            _productImage!,
          ).then((downloadURL) {
            addProduct(
              downloadURL,
              productName,
              description,
              price,
              salePrice,
              category,
              isFeatured,
            ).then((v) {
              Navigator.pop(context, "done");
            });
          }).catchError((e) {
            debugPrint(e.toString());
            Navigator.pop(context, "failed");
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

  _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      builder: (ctx) {
        return Container(
          height: 200,
          color: Colors.transparent,
          child: ListView(
            children: [
              // check hasImage ? Image.asset(path) :
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take a Picture from Camera"),
                onTap: () {
                  _takeImage(ImagePickCategory.camera);

                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Select a Picture from Device"),
                onTap: () {
                  _takeImage(ImagePickCategory.phone);
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _takeImage(ImagePickCategory selection) async {
    try {
      final picker = ImagePicker();

      File? tempFile;

      // pick image
      if (selection == ImagePickCategory.camera) {
        final pickedFile = await picker.pickImage(source: ImageSource.camera);
        tempFile = File(pickedFile!.path);
      } else if (selection == ImagePickCategory.phone) {
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        tempFile = File(pickedFile!.path);
      }

      // crop image

      CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: tempFile!.path,
          compressQuality: compressQuality,
          compressFormat: ImageCompressFormat.jpg,
          maxHeight: maxHeight,
          maxWidth: maxWidth,
          uiSettings: [
            WebUiSettings(
                context: context,
                boundary: CroppieBoundary(height: 500, width: 400),
                viewPort:
                    CroppieViewPort(width: 300, height: 250, type: 'square'),
                enableZoom: true)
          ]);
      if (croppedFile != null) {
        final path = croppedFile.path;
        File cFile = File(path);
        // debugPrint(cFile.lengthSync().toString());

        setState(() {
          _productImage = cFile;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Product"),
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
                    InkWell(
                      onTap: () {
                        _pickImage();
                      },
                      child: _productImage == null
                          ? Container(
                              height: 280,
                              color: Colors.grey,
                              child: const Icon(Icons.add_a_photo),
                            )
                          : Image.file(
                              _productImage!,
                              height: 280,
                              fit: BoxFit.cover,
                            ),
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
                    if (_categories!.isNotEmpty && _categories!.isNotEmpty) ...[
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          labelText: "Category",
                        ),
                        items: _categories!.map((c) {
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
                        onCreateProductBtnTap();
                      },
                      child: const Text("CREATE PRODUCT"),
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
