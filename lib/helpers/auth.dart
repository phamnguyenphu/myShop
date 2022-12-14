

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

Future<UserCredential?> signInWithGoogle() async {
  try {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      clientId:
          '718811808810-l903mh4115amp3s47v539s4ff3jrd6bc.apps.googleusercontent.com',
    ).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await auth.signInWithCredential(credential);
  } catch (e) {
    debugPrint(e.toString());
    return null;
  }
}

Future<UserCredential?> signIn(String emailUser, String passwordUser) async {
  try {
    final credential = await auth.signInWithEmailAndPassword(
      email: emailUser,
      password: passwordUser,
    );
    return credential;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}

Future<UserCredential?> registerAccount(String emailUser, String passwordUser,
    String displayNameUser, String phoneUser) async {
  try {
    final credential = await auth.createUserWithEmailAndPassword(
      email: emailUser,
      password: passwordUser,
    );
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection("users").doc(credential.user!.uid).set(
      {
        "displayName": displayNameUser,
        "email": credential.user!.email,
        "photoUrl": "",
        "isAdmin": false,
        "uid": credential.user!.uid,
        "phone": phoneUser,
      },
      SetOptions(merge: true),
    );
    return credential;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}

void authStateChanges() {
  auth.authStateChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });
}

Future<void> signOut() async {
  return await auth.signOut();
}
