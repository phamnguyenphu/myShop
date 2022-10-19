import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

final User? user = auth.currentUser;

editPhoneNumber(String phone, String altPhone) {
  return firestore
      .collection("users")
      .doc(user!.uid)
      .set({"phone": phone, "altPhone": altPhone}, SetOptions(merge: true));
}

editAddress(String homeAddress, String officeAddress) {
  return firestore.collection("users").doc(user!.uid).set(
      {"homeAddress": homeAddress, "officeAddress": officeAddress},
      SetOptions(merge: true));
}

Future<DocumentSnapshot> getUserData() {
  return firestore.collection("users").doc(user!.uid).get();
}

Future<DocumentSnapshot> getUserDataById(String uid) {
  return firestore.collection("users").doc(uid).get();
}

Future<QuerySnapshot> searchUser(String searchValue, String searchBy) async {
  return await firestore
      .collection("users")
      .where(searchBy, isEqualTo: searchValue)
      .limit(1)
      .get();
}
