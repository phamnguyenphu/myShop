import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myshop/helpers/auth.dart';

class AccountTab extends StatelessWidget {
  const AccountTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        UserAccountsDrawerHeader(
          accountName:
              Text(FirebaseAuth.instance.currentUser!.displayName ?? ""),
          accountEmail: Text(FirebaseAuth.instance.currentUser!.email ?? ""),
          currentAccountPicture: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
                FirebaseAuth.instance.currentUser!.photoURL ?? ""),
          ),
        ),
        const Divider(),
        ListTile(
          title: const Text("Edit My Address"),
          onTap: () {
            Navigator.pushNamed(context, "/edit_my_address");
          },
        ),
        const Divider(),
        ListTile(
          title: const Text("Edit My Phone"),
          onTap: () {
            Navigator.pushNamed(context, "/edit_my_phone_number");
          },
        ),
        const Divider(),
        ListTile(
          title: const Text("Logout"),
          onTap: () {
            signOut().then((v) {
              Navigator.pushReplacementNamed(context, "/");
            });
          },
        ),
      ],
    );
  }
}
