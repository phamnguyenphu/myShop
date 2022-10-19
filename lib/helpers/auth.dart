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

Future<void> signOut() async {
  return await auth.signOut();
}
