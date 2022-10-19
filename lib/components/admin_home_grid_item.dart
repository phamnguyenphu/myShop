import 'package:flutter/material.dart';

class AdminHomeGridItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;

  final Function onTap;

  const AdminHomeGridItem(
      {Key? key,
      required this.icon,
      this.iconColor = Colors.amber,
      this.text = "",
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            await Future.delayed(const Duration(milliseconds: 300));
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50, color: iconColor),
                const SizedBox(
                  height: 5,
                ),
                Text(text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
