import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<void> createCategory(String title) async {
  return await firestore.collection("categories").doc(title).set({
    "title": title,
  }, SetOptions(merge: true));
}

Future<QuerySnapshot> getCategories() async {
  return await firestore.collection("categories").get();
}

Future<void> deleteCategory(String id) async {
  return await firestore.collection("categories").doc(id).delete();
}
