import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:myshop/config/theme.dart';
import 'package:myshop/pages/about_shop_details.dart';
import 'package:myshop/pages/admin/desktop/search_screen.dart';
import 'package:myshop/pages/all_products_screen.dart';
import 'package:myshop/pages/cart_screen.dart';
import 'package:myshop/pages/edit_my_address_screen.dart';
import 'package:myshop/pages/edit_my_phone_screen.dart';
import 'package:myshop/pages/home_screen.dart';
import 'package:myshop/pages/register_screen.dart';
import 'package:myshop/pages/shop_by_category_screen.dart';
import 'package:myshop/pages/splash_screen.dart';
import 'package:myshop/pages/admin/admin_home_screen.dart';
import 'package:myshop/pages/admin/categories_screen.dart';
import 'package:myshop/pages/admin/create_product_screen.dart';
import 'package:myshop/pages/admin/orders_screen_admin.dart';
import 'package:myshop/pages/admin/products_screen.dart';
import 'package:myshop/pages/admin/shop_details.dart';
import 'package:myshop/pages/admin/user_details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    Stripe.publishableKey =
        'pk_test_51K7c3jLZFf69SCa4UmIugNRO6W3vNQ5FXRo6EfhkWd4OOZjiIBhFID1bz1j59qv2QuJdQVf4xYwFSkXnuo6kQ2JH002Yp4txgs';
  }

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBBsa8kXpz2MkXpJqgTmvyl26UKOiHvbS4",
            appId: "1:718811808810:web:322d51588d7cd45b4e6f53",
            messagingSenderId: "718811808810",
            projectId: "myshop-kltn"),
      );
    }
    await Firebase.initializeApp();
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
        "/search_screen": (context) => const SearchScreen(),
        "/all_product": (context) => const AllProductScreen(),
        "/register": (context) => const RegisterScreen(),
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
