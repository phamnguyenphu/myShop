import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myshop/components/admin_home_grid_item.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/config/strings.dart';
import 'package:myshop/helpers/auth.dart';
import 'package:myshop/pages/admin/desktop/desktop_admin_home_page.dart';
import 'package:myshop/responsive/responsive_layout.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        desktopBody: DesktopAdminHomeScreen(),
        mobileBody: Scaffold(
          appBar: AppBar(
            title: const Text("$appName Admin"),
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                      FirebaseAuth.instance.currentUser!.displayName ?? ""),
                  accountEmail:
                      Text(FirebaseAuth.instance.currentUser!.email ?? ""),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      FirebaseAuth.instance.currentUser!.photoURL ??
                          "https://w7.pngwing.com/pngs/831/88/png-transparent-user-profile-computer-icons-user-interface-mystique-miscellaneous-user-interface-design-smile-thumbnail.png",
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: primaryColor,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, "/home");
                  },
                  title: const Text("Goto to Buyer Mode"),
                  leading: const Icon(EvaIcons.shoppingCartOutline),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, "/manage_products");
                  },
                  title: const Text("Manage Products"),
                  leading: const Icon(EvaIcons.briefcase),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, "/categories_admin");
                  },
                  title: const Text("Manage Categories"),
                  leading: const Icon(EvaIcons.grid),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, "/admin_orders");
                  },
                  title: const Text("Manage Orders"),
                  leading: const Icon(EvaIcons.browser),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, "/user_details");
                  },
                  title: const Text("Manage Users"),
                  leading: const Icon(EvaIcons.person),
                ),
                ListTile(
                  onTap: () {
                    signOut().then((e) {
                      Navigator.pushReplacementNamed(context, "/");
                    }).catchError((e) {
                      debugPrint(e.toString());
                    });
                  },
                  title: const Text("Logout"),
                  leading: const Icon(EvaIcons.logOutOutline),
                ),
              ],
            ),
          ),
          body: GridView.count(
            crossAxisCount: 2,
            children: [
              AdminHomeGridItem(
                icon: Icons.category,
                text: "Products",
                onTap: () {
                  Navigator.pushNamed(context, "/manage_products");
                },
                iconColor: Colors.blue,
              ),
              AdminHomeGridItem(
                icon: Icons.local_offer,
                text: "Categories",
                onTap: () {
                  Navigator.pushNamed(context, "/categories_admin");
                },
                iconColor: Colors.deepOrangeAccent,
              ),
              AdminHomeGridItem(
                icon: Icons.local_shipping,
                text: "Orders",
                onTap: () {
                  Navigator.pushNamed(context, "/admin_orders");
                },
              ),
              AdminHomeGridItem(
                icon: Icons.people,
                text: "Users",
                onTap: () {
                  Navigator.pushNamed(context, "/user_details");
                },
                iconColor: Colors.brown,
              ),
              AdminHomeGridItem(
                icon: Icons.storefront,
                text: "Shop Details",
                onTap: () {
                  Navigator.pushNamed(context, "/edit_shop_details");
                },
                iconColor: Colors.deepPurple,
              ),
            ],
          ),
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text("$appName Admin"),
    //   ),
    //   drawer: Drawer(
    //     child: ListView(
    //       children: [
    //         UserAccountsDrawerHeader(
    //           accountName:
    //               Text(FirebaseAuth.instance.currentUser!.displayName ?? ""),
    //           accountEmail: Text(FirebaseAuth.instance.currentUser!.email ?? ""),
    //           currentAccountPicture: CircleAvatar(
    //             backgroundImage: CachedNetworkImageProvider(
    //                 FirebaseAuth.instance.currentUser!.photoURL ?? ""),
    //           ),
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(16),
    //             color: primaryColor,
    //           ),
    //         ),
    //         ListTile(
    //           onTap: () {
    //             Navigator.pushNamed(context, "/home");
    //           },
    //           title: const Text("Goto to Buyer Mode"),
    //           leading: const Icon(EvaIcons.shoppingCartOutline),
    //         ),
    //         ListTile(
    //           onTap: () {
    //             signOut().then((e) {
    //               Navigator.pushReplacementNamed(context, "/");
    //             }).catchError((e) {
    //               debugPrint(e.toString());
    //             });
    //           },
    //           title: const Text("Logout"),
    //           leading: const Icon(EvaIcons.logOutOutline),
    //         ),
    //       ],
    //     ),
    //   ),
    //   body: GridView.count(
    //     crossAxisCount: 2,
    //     children: [
    //       AdminHomeGridItem(
    //         icon: Icons.category,
    //         text: "Products",
    //         onTap: () {
    //           Navigator.pushNamed(context, "/manage_products");
    //         },
    //         iconColor: Colors.blue,
    //       ),
    //       AdminHomeGridItem(
    //         icon: Icons.local_offer,
    //         text: "Categories",
    //         onTap: () {
    //           Navigator.pushNamed(context, "/categories_admin");
    //         },
    //         iconColor: Colors.deepOrangeAccent,
    //       ),
    //       AdminHomeGridItem(
    //         icon: Icons.local_shipping,
    //         text: "Orders",
    //         onTap: () {
    //           Navigator.pushNamed(context, "/admin_orders");
    //         },
    //       ),
    //       AdminHomeGridItem(
    //         icon: Icons.people,
    //         text: "Users",
    //         onTap: () {
    //           Navigator.pushNamed(context, "/user_details");
    //         },
    //         iconColor: Colors.brown,
    //       ),
    //       AdminHomeGridItem(
    //         icon: Icons.storefront,
    //         text: "Shop Details",
    //         onTap: () {
    //           Navigator.pushNamed(context, "/edit_shop_details");
    //         },
    //         iconColor: Colors.deepPurple,
    //       ),
    //     ],
    //   ),
    // );
  }
}
