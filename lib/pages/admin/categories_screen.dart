import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/components/empty.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/helpers/category.dart';
import 'package:myshop/pages/admin/create_category_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  CategoriesScreenState createState() => CategoriesScreenState();
}

class CategoriesScreenState extends State<CategoriesScreen> {
  bool _isLoading = false;
  bool _isEmpty = true;

  late List<QueryDocumentSnapshot> categories;

  @override
  void initState() {
    _loadCategories();
    super.initState();
  }

  _loadCategories() async {
    setState(() {
      _isLoading = true;
    });

    QuerySnapshot qSnap = await getCategories();

    if (qSnap.size > 0) {
      setState(() {
        _isEmpty = false;
        _isLoading = false;
        categories = qSnap.docs;
      });
    } else {
      setState(() {
        _isEmpty = true;
        _isLoading = false;
      });
    }
  }

  onDeleteCategoryBtnTap(String catId) async {
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
                deleteCategory(catId).then((value) {
                  _loadCategories();
                  Navigator.pop(ctx);
                }).catchError((e) {
                  debugPrint(e.toString());
                });
              },
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
        title: const Text("Categories Screen"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          String result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateCategoryScreen(),
              fullscreenDialog: true,
            ),
          );

          if (result == "added") {
            _loadCategories();
          }
        },
        label: const Text("Add Category"),
        icon: const Icon(Icons.add),
      ),
      body: _isLoading == true
          ? const Center(
              child: SpinKitChasingDots(
              color: primaryColor,
              size: 50,
            ))
          : Container(
              child: _isEmpty == true
                  ? const Empty(
                      text: "No Categories found, Add some 🙆🏻‍♀️ ",
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        return _loadCategories();
                      },
                      child: ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (ctx, i) {
                          Map<String, dynamic>? caty =
                              categories[i].data() as Map<String, dynamic>?;
                          return Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text(
                                  caty!["title"],
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                IconButton(
                                  tooltip: "Delete",
                                  color: Colors.red,
                                  icon: const Icon(Icons.delete_forever),
                                  onPressed: () {
                                    onDeleteCategoryBtnTap(categories[i].id);
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
    );
  }
}
