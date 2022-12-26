import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/helpers/auth.dart';

import '../config/colors.dart';
import '../helpers/user.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({Key? key}) : super(key: key);

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  Map<String, dynamic>? user;
  bool _loading = false;

  @override
  void initState() {
    fetchUData();
    super.initState();
  }

  fetchUData() async {
    setState(() {
      _loading = true;
    });
    DocumentSnapshot doc =
        await getUserDataById(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      user = doc.data() as Map<String, dynamic>?;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading == true) {
      return const Center(
        child: SpinKitChasingDots(
          color: primaryColor,
          size: 50,
        ),
      );
    } else {
      return ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user!['displayName'].toString()),
            accountEmail: Text(user!['email'].toString()),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                  'https://w7.pngwing.com/pngs/831/88/png-transparent-user-profile-computer-icons-user-interface-mystique-miscellaneous-user-interface-design-smile-thumbnail.png'),
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
}
