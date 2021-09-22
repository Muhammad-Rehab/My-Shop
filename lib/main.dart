import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:real_shop/screens/add_product_screen.dart';
import 'package:real_shop/screens/favorite_screen.dart';
import 'package:real_shop/screens/splash_screen.dart';
import 'providers/auth.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
import 'providers/products.dart';
import 'screens/auth_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/order_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/product_overview_screen.dart';
import 'screens/user_products_screen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => AuthProvider(),
        ),
        ChangeNotifierProvider.value(value: CartProvider()),
        ChangeNotifierProvider.value(value: OrdersProvider()),
        // ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
        //   create: (_) => OrdersProvider(),
        //   update: (context, authProvider, orderProvider) =>
        //       orderProvider!.getOrders(),
        // ),
        // ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
        //   create: (_) => ProductsProvider(),
        //   update: (_, authProvider, productProvider) {
        //     return productProvider!.currentUser() ;
        //   }
        //
        // ),
        ChangeNotifierProvider.value(value: ProductsProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (BuildContext context, value, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.purple,
            primarySwatch: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: (FirebaseAuth.instance.currentUser == null ||
                  FirebaseAuth.instance.currentUser!.uid.isEmpty)
              ? AuthScreen()
              : FutureBuilder(
                  future: FirebaseAuth.instance.currentUser!.getIdToken(),
                  builder: (ctx, snapShot) {
                    if (snapShot.connectionState == ConnectionState.waiting) {
                      return SplashScreen();
                    } else {
                      return ProductOverviewScreen();
                    }
                  },
                ),
          routes: {
            AddProductScreen.route : (_)=> AddProductScreen(),
            FavoriteScreen.route : (_)=> FavoriteScreen(),
            ProductDetailsScreen.rout: (_) => ProductDetailsScreen(),
            CartScreen.rout: (_) => CartScreen(),
            OrderScreen.rout: (_) => OrderScreen(),
            UserProductScreen.rout: (_) => UserProductScreen(),
          },
        ),
      ),
    );
  }
}
