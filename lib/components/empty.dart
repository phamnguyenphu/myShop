import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  final String text;
  final double height;

  const Empty({Key? key, required this.text, this.height = 300})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: const AssetImage("assets/women_jacket.png"),
            height: height,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(text),
        ],
      ),
    );
  }
}
