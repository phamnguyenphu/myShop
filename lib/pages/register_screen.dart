import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myshop/components/text_field_auth.dart';
import 'package:myshop/helpers/auth.dart';

import '../config/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _displayName = TextEditingController(text: "");
  final TextEditingController _emailAddress = TextEditingController(text: "");
  final TextEditingController _phoneNumber = TextEditingController(text: "");
  final TextEditingController _password = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
              image: const AssetImage("assets/register_icon.png"),
              color: buttonColor,
            ),
            Text(
              "Register",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.left,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldAuth(
                  controller: _displayName,
                  prefix: const Icon(Icons.person_outline),
                  hint: "Display Name",
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 24),
                TextFieldAuth(
                  controller: _emailAddress,
                  prefix: const Icon(Icons.alternate_email_rounded),
                  hint: "Email Address",
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 24),
                TextFieldAuth(
                  controller: _phoneNumber,
                  prefix: const Icon(Icons.phone_outlined),
                  hint: "Phone Number",
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 24),
                TextFieldAuth(
                  controller: _password,
                  obscureText: true,
                  prefix: const Icon(Icons.lock_outline_rounded),
                  suffix: const Icon(Icons.remove_red_eye_outlined),
                  hint: "Password",
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "By signing up, you're agree to our ",
                        style: Theme.of(context).textTheme.button,
                      ),
                      TextSpan(
                        text: "Term & Condition",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            ?.copyWith(color: primaryColor),
                      ),
                      TextSpan(
                        text: " and ",
                        style: Theme.of(context).textTheme.button,
                      ),
                      TextSpan(
                        text: "privacy Policy",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            ?.copyWith(color: primaryColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await registerAccount(_emailAddress.text, _password.text, _displayName.text, _phoneNumber.text);
                        print("đang ky");
                      }
                      catch (e) {
                        debugPrint(e.toString());
                      }


                      // Navigator.pushNamed(
                      //   context,
                      //   "",
                      // );ff
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    child: const Text("Register"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
