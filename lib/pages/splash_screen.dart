import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myshop/config/links.dart';
import 'package:myshop/config/strings.dart';
import 'package:myshop/helpers/auth.dart';
import 'package:myshop/helpers/user.dart';
import 'package:auth_buttons/auth_buttons.dart'
    show AuthButtonStyle, AuthButtonType, GoogleAuthButton;
import 'package:url_launcher/url_launcher_string.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
      checkUserAuth();
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  void checkUserAuth() async {
    final auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((user) async {
      if (user != null) {
        // Navigator.pushReplacementNamed(context, "/home");
        getUserData().then((DocumentSnapshot u) {
          Map<String, dynamic> udata = u.data() as Map<String, dynamic>;
          final bool isAdmin = udata["isAdmin"];

          if (isAdmin == true) {
            Navigator.pushReplacementNamed(context, "/admin");
          } else {
            Navigator.pushReplacementNamed(context, "/home");
          }
        }).catchError((e) {
          debugPrint(e.toString());
        });
      } else {
        // user is signed out
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return const Scaffold(
        body: Center(
          child: Text("Please try again later..."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 50),
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(64),
                  child: const Image(
                    image: AssetImage("assets/icon_alt.png"),
                    width: 256,
                    height: 256,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  appName,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    appSubtitle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(32, 31, 16, 62),
                    blurRadius: 60,
                    offset: Offset(0, -10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 34,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Link your Account to $appName, so you can get order updates, and save your information",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                  if (_initialized) ...[
                    Center(
                      child: GoogleAuthButton(
                        onPressed: () async {
                          try {
                            final u = await signInWithGoogle();
                            // print(u);

                            final FirebaseFirestore firestore =
                                FirebaseFirestore.instance;

                            User? user = u!.user;

                            await firestore
                                .collection("users")
                                .doc(user!.uid)
                                .set({
                              "displayName": user.displayName,
                              "email": user.email,
                              "photoURL": user.photoURL,
                              "uid": user.uid,
                            }, SetOptions(merge: true));
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        },
                        darkMode: false,
                        text: "Sign in with Google",
                        isLoading: !_initialized,
                        style: const AuthButtonStyle(
                          buttonType: AuthButtonType.icon,
                          borderRadius: 18,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Center(
                    child: Wrap(
                      children: [
                        TextButton(
                          onPressed: () {
                            _launchURL(privacyPolicyURL);
                          },
                          child: const Text("Privacy Policy"),
                        ),
                        TextButton(
                          onPressed: () {
                            _launchURL(termsAndConditionsURL);
                          },
                          child: const Text("Terms & Conditions"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
