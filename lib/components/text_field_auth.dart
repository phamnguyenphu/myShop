import 'package:flutter/material.dart';

class TextFieldAuth extends StatelessWidget {
  TextFieldAuth({
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.hint,
    this.obscureText = false,
    this.prefix,
    this.suffix,
  });

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? prefix;
  final Widget? suffix;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (prefix != null) ...[
          prefix!,
          const SizedBox(width: 10),
        ],
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              suffixIcon: suffix,
              hintText: hint,
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
