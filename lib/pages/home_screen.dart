import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/config/links.dart';
import 'package:myshop/config/strings.dart';
import 'package:myshop/pages/account_tab.dart';
import 'package:myshop/pages/home_tab.dart';
import 'package:myshop/pages/orders_tab.dart';
import 'package:myshop/pages/search_tab.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;

  // tabs
  final _tabs = [
    const HomeTab(),
    const SearchTab(),
    const OrdersTab(),
    const AccountTab()
  ];
  // tabs

  @override
  void initState() {
    super.initState();
  }

  void _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
        actions: [
          IconButton(
            tooltip: "Cart",
            icon: const Icon(EvaIcons.shoppingCartOutline),
            onPressed: () {
              Navigator.pushNamed(context, "/cart");
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName:
                  Text(FirebaseAuth.instance.currentUser!.displayName ?? ""),
              accountEmail:
                  Text(FirebaseAuth.instance.currentUser!.email ?? ""),
              currentAccountPicture: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(

                    FirebaseAuth.instance.currentUser!.photoURL ?? ""),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: primaryColor,
              ),
            ),
            ListTile(
              onTap: () {},
              title: const Text("Home"),
              leading: const Icon(EvaIcons.gridOutline),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, "/shop_by_category");
              },
              title: const Text("Shop By Category"),
              leading: const Icon(Icons.category_outlined),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, "/cart");
              },
              title: const Text("Cart"),
              leading: const Icon(EvaIcons.shoppingCartOutline),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, "/about");
              },
              title: const Text("About $appName"),
              leading: const Icon(EvaIcons.infoOutline),
            ),
            ListTile(
              onTap: () {
                _launchURL(privacyPolicyURL);
              },
              title: const Text("Privacy Policy"),
              leading: const Icon(EvaIcons.fileTextOutline),
            ),
            ListTile(
              onTap: () {
                _launchURL(termsAndConditionsURL);
              },
              title: const Text("Terms and Conditions"),
              leading: const Icon(EvaIcons.fileTextOutline),
            ),
          ],
        ),
      ),
      body: SizedBox.expand(
        child: _tabs[_currentTab],
      ),
      bottomNavigationBar: BottomNavyBar(
        curve: Curves.ease,
        selectedIndex: _currentTab,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        onItemSelected: (i) {
          setState(() {
            _currentTab = i;
          });
        },
        items: [
          BottomNavyBarItem(
            activeColor: primaryColor,
            inactiveColor: Colors.grey,
            textAlign: TextAlign.center,
            title: const Text("Home"),
            icon: const Icon(EvaIcons.gridOutline),
          ),
          BottomNavyBarItem(
            activeColor: primaryColor,
            inactiveColor: Colors.grey,
            textAlign: TextAlign.center,
            title: const Text("Search"),
            icon: const Icon(EvaIcons.searchOutline),
          ),
          BottomNavyBarItem(
            activeColor: primaryColor,
            inactiveColor: Colors.grey,
            textAlign: TextAlign.center,
            title: const Text("Orders"),
            icon: const Icon(EvaIcons.shoppingBagOutline),
          ),
          BottomNavyBarItem(
            activeColor: primaryColor,
            inactiveColor: Colors.grey,
            textAlign: TextAlign.center,
            title: const Text("Profile"),
            icon: const Icon(EvaIcons.personOutline),
          ),
        ],
      ),
    );
  }
}
