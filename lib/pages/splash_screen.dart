import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myshop/components/text_field_auth.dart';
import 'package:myshop/config/colors.dart';
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
  final TextEditingController _email = TextEditingController(text: "");
  final TextEditingController _password = TextEditingController(text: "");
  String email = "";
  String password = "";

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    // TODO: implement dispose
    super.dispose();
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
      body: Padding(
        padding: const EdgeInsets.only(
          top: 12,
          bottom: 12,
          left: 24,
          right: 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              width: MediaQuery.of(context).size.width,
              height: 250,
              fit: BoxFit.contain,
              image: const AssetImage("assets/login_icon.png"),
              filterQuality: FilterQuality.high,
              color: buttonColor,
            ),
            Text(
              "Login",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width > 600
                  ? MediaQuery.of(context).size.width / 2
                  : double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.alternate_email_outlined),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          obscureText: false,
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            hintText: "Email Address",
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.lock_outline_rounded),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _password,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          obscureText: false,
                          decoration: InputDecoration(
                            suffixIcon:
                                const Icon(Icons.remove_red_eye_outlined),
                            border: const UnderlineInputBorder(),
                            hintText: "Password",
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // TextFieldAuth(
                  //   controller: _password,
                  //   obscureText: true,
                  //   prefix: const Icon(Icons.lock_outline_rounded),
                  //   suffix: const Icon(Icons.remove_red_eye_outlined),
                  //   hint: "Password",
                  //   textInputAction: TextInputAction.done,
                  // ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Navigator.pushNamed(
                  //   context,
                  //   AppRouteName.forgotPassword,
                  // );
                },
                child: const Text("Forgot Password ?"),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 64,
              child: ElevatedButton(
                onPressed: () async {
                  final user = await signIn(_email.text, _password.text);
                  checkUserAuth();
                  print(user!.user);
                  print("LOGIN");
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                child: const Text("Login"),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text("OR"),
                ),
                Expanded(child: Divider()),
              ],
            ),
            if (_initialized) ...[
              GoogleAuthButton(
                onPressed: () async {
                  try {
                    final u = await signInWithGoogle();
                    // print(u);

                    final FirebaseFirestore firestore =
                        FirebaseFirestore.instance;

                    User? user = u!.user;

                    await firestore.collection("users").doc(user!.uid).set({
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
                isLoading: !_initialized,
                style: const AuthButtonStyle(
                  borderRadius: 16,
                  height: 64,
                  width: double.infinity,
                ),
              ),
            ],
            Align(
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Don't have an Account ? ",
                      style: Theme.of(context).textTheme.button,
                    ),
                    TextSpan(
                      text: "Register here!",
                      style: Theme.of(context)
                          .textTheme
                          .button
                          ?.copyWith(color: buttonColor),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        Navigator.pushNamed(context, "/register");
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(),
    //   extendBodyBehindAppBar: true,
    //   body: Stack(
    //     children: [
    //       Container(
    //         margin: const EdgeInsets.only(top: 50),
    //         alignment: Alignment.topCenter,
    //         child: Column(
    //           children: [
    //             ClipRRect(
    //               borderRadius: BorderRadius.circular(64),
    //               child: const Image(
    //                 image: AssetImage("assets/icon_alt.png"),
    //                 width: 256,
    //                 height: 256,
    //               ),
    //             ),
    //             const SizedBox(height: 20),
    //             const Text(
    //               appName,
    //               style: TextStyle(
    //                 fontSize: 34,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //               textAlign: TextAlign.center,
    //             ),
    //             const Padding(
    //               padding: EdgeInsets.symmetric(horizontal: 25.0),
    //               child: Text(
    //                 appSubtitle,
    //                 textAlign: TextAlign.center,
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //       Positioned(
    //         bottom: 0,
    //         child: Container(
    //           width: MediaQuery.of(context).size.width,
    //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
    //           decoration: const BoxDecoration(
    //             color: Colors.white,
    //             borderRadius: BorderRadius.only(
    //               topLeft: Radius.circular(32),
    //               topRight: Radius.circular(32),
    //             ),
    //             boxShadow: [
    //               BoxShadow(
    //                 color: Color.fromARGB(32, 31, 16, 62),
    //                 blurRadius: 60,
    //                 offset: Offset(0, -10),
    //               ),
    //             ],
    //           ),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               const Text(
    //                 "Login",
    //                 style: TextStyle(
    //                   fontSize: 34,
    //                 ),
    //               ),
    //               const SizedBox(height: 5),
    //               const Text(
    //                 "Link your Account to $appName, so you can get order updates, and save your information",
    //                 style: TextStyle(color: Colors.grey),
    //               ),
    //               const SizedBox(height: 40),
    //               if (_initialized) ...[
    //                 Center(
    //                   child: GoogleAuthButton(
    //                     onPressed: () async {
    //                       try {
    //                         final u = await signInWithGoogle();
    //                         // print(u);
    //
    //                         final FirebaseFirestore firestore =
    //                             FirebaseFirestore.instance;
    //
    //                         User? user = u!.user;
    //
    //                         await firestore
    //                             .collection("users")
    //                             .doc(user!.uid)
    //                             .set({
    //                           "displayName": user.displayName,
    //                           "email": user.email,
    //                           "photoURL": user.photoURL,
    //                           "uid": user.uid,
    //                         }, SetOptions(merge: true));
    //                       } catch (e) {
    //                         debugPrint(e.toString());
    //                       }
    //                     },
    //                     darkMode: false,
    //                     text: "Sign in with Google",
    //                     isLoading: !_initialized,
    //                     style: const AuthButtonStyle(
    //                       buttonType: AuthButtonType.icon,
    //                       borderRadius: 18,
    //                       width: double.infinity,
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //               const SizedBox(height: 20),
    //               Center(
    //                 child: Wrap(
    //                   children: [
    //                     TextButton(
    //                       onPressed: () async {
    //                         final u = await signIn("test123@gmail.com", "123456");
    //                         final FirebaseFirestore firestore =
    //                             FirebaseFirestore.instance;
    //
    //                         User? user = u!.user;
    //
    //                         await firestore
    //                             .collection("users")
    //                             .doc(user!.uid)
    //                             .set({
    //                           "displayName": "pham nguyen phu",
    //                           "email": user.email,
    //                           "photoUrl": "https://lh3.googleusercontent.com/a-/ACNPEu9wdy0OAJCTRop6pQTWyqXXaMX-15uVqPAVmsrdNQ=s96-c",
    //                           "uid": user.uid,
    //                           "isAdmin": true,
    //                         }, SetOptions(merge: true));
    //                         checkUserAuth();
    //                       },
    //                       child: const Text("Privacy Policy"),
    //                     ),
    //                     TextButton(
    //                       onPressed: () {
    //                         _launchURL(termsAndConditionsURL);
    //                       },
    //                       child: const Text("Terms & Conditions"),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
