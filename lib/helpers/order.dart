import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;

Future<DocumentReference> addOrderPayOnDelivery(
    List cart,
    double cartItemsTotal,
    int tax,
    double taxAmount,
    double total,
    String addressType,
    String address,
    String phone) async {
  return await firestore.collection("orders").add({
    "uid": user!.uid,
    "paymentMethod": "payOnDelivery",
    "orderStatus": "ordered", // ordered, delivering, delivered, cancelled
    "paymentStatus": "notPaid", // notPaid, paid
    "addressType": addressType,
    "address": address,
    "phone": phone,
    "created_at": FieldValue.serverTimestamp(),
    "updated_at": FieldValue.serverTimestamp(),
    "cart": cart,
    "cartItemsTotal": cartItemsTotal,
    "tax": tax,
    "taxAmount": taxAmount,
    "total": total
  });
}

Future<DocumentReference> addOrderPayVisaCard(
    List cart,
    double cartItemsTotal,
    int tax,
    double taxAmount,
    double total,
    String addressType,
    String address,
    String phone) async {
  return await firestore.collection("orders").add({
    "uid": user!.uid,
    "paymentMethod": "payOnVisaCard",
    "orderStatus": "ordered", // ordered, delivering, delivered, cancelled
    "paymentStatus": "Paid", // notPaid, paid
    "addressType": addressType,
    "address": address,
    "phone": phone,
    "created_at": FieldValue.serverTimestamp(),
    "updated_at": FieldValue.serverTimestamp(),
    "cart": cart,
    "cartItemsTotal": cartItemsTotal,
    "tax": tax,
    "taxAmount": taxAmount,
    "total": total
  });
}

Future<DocumentReference> addOrderSelfPickup(
  List cart,
  double cartItemsTotal,
  int tax,
  double taxAmount,
  double total,
) async {
  return await firestore.collection("orders").add({
    "uid": user!.uid,
    "paymentMethod": "selfPickup",
    "orderStatus": "ordered", // ordered, delivering, delivered, cancelled
    "paymentStatus": "notPaid", // notPaid, paid
    "created_at": FieldValue.serverTimestamp(),
    "updated_at": FieldValue.serverTimestamp(),
    "cart": cart,
    "cartItemsTotal": cartItemsTotal,
    "tax": tax,
    "taxAmount": taxAmount,
    "total": total
  });
}

Future<QuerySnapshot> getAllOrdersOfUser() async {
  return await firestore
      .collection("orders")
      .where("uid", isEqualTo: user!.uid)
      .orderBy("created_at", descending: true)
      .get();
}

Future<QuerySnapshot> getOrders(String orderStatus) async {
  return await firestore
      .collection("orders")
      .where("orderStatus", isEqualTo: orderStatus)
      .orderBy("created_at", descending: true)
      .limit(20)
      .get();
}

Future<QuerySnapshot> getMoreOrders(
    String orderStatus, DocumentSnapshot lastDocument) async {
  return await firestore
      .collection("orders")
      .where("orderStatus", isEqualTo: orderStatus)
      .orderBy("created_at", descending: true)
      .startAfterDocument(lastDocument)
      .limit(20)
      .get();
}

Future<void> updateOrderStatus(String id, String status) async {
  if (status == "delivered") {
    return await firestore.collection("orders").doc(id).update({
      "paymentStatus": "paid",
      "orderStatus": status,
    });
  } else {
    return await firestore.collection("orders").doc(id).update({
      "orderStatus": status,
    });
  }
}
