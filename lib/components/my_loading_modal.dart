import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/config/colors.dart';

void showMyLoadingModal(BuildContext context, String text) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: Text(text),
        children: const [
          SpinKitChasingDots(
            color: primaryColor,
            size: 50,
          ),
        ],
      );
    },
  );
}
