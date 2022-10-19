import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myshop/config/theme.dart';
import 'package:myshop/pages/about_shop_details.dart';
import 'package:myshop/pages/cart_screen.dart';
import 'package:myshop/pages/edit_my_address_screen.dart';
import 'package:myshop/pages/edit_my_phone_screen.dart';
import 'package:myshop/pages/home_screen.dart';
import 'package:myshop/pages/shop_by_category_screen.dart';
import 'package:myshop/pages/splash_screen.dart';
import 'package:myshop/pages/admin/admin_home_screen.dart';
import 'package:myshop/pages/admin/categories_screen.dart';
import 'package:myshop/pages/admin/create_product_screen.dart';
import 'package:myshop/pages/admin/orders_screen_admin.dart';
import 'package:myshop/pages/admin/products_screen.dart';
import 'package:myshop/pages/admin/shop_details.dart';
import 'package:myshop/pages/admin/user_details_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      name: "My fresh shop",
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint(e.toString());
  }

  runApp(App());
}

class App extends StatelessWidget {
  final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;

  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarBrightness: Brightness.dark,
    //   statusBarColor: primaryColor,
    //   statusBarIconBrightness: Brightness.dark,
    //   systemNavigationBarColor: Colors.white,
    //   systemNavigationBarIconBrightness: Brightness.dark,
    // ));

    return MaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: firebaseAnalytics),
      ],
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashScreen(),
        "/admin": (context) => const AdminHomeScreen(),
        "/admin_orders": (context) => const OrdersScreenAdmin(),
        "/home": (context) => const HomeScreen(),
        "/about": (context) => const AboutShopDetails(),
        "/edit_my_phone_number": (context) => const EditMyPhoneScreen(),
        "/edit_my_address": (context) => const EditMyAddressScreen(),
        "/edit_shop_details": (context) => const ShopDetailsScreen(),
        "/user_details": (context) => const UserDetailsScreen(),
        "/manage_products": (context) => const ProductsScreen(),
        "/create_product": (context) => const CreateProductScreen(),
        "/categories_admin": (context) => const CategoriesScreen(),
        "/cart": (context) => const CartScreen(),
        "/shop_by_category": (context) => const ShopByCategoryScreen(),
      },
    );
  }
}
