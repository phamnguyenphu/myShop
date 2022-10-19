import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
Future<void> editShopDetails(
    {String? shopName,
    String? address,
    String? phone,
    String? email,
    String? taxNumber,
    double? tax}) async {
  return await firestore.collection("store").doc("details").set({
    "shopName": shopName,
    "address": address,
    "phone": phone,
    "email": email,
    "taxNumber": taxNumber,
    "tax": tax
  }, SetOptions(merge: true));
}

Future<DocumentSnapshot> getShopDetails() async {
  return await firestore.collection("store").doc("details").get();
}
