
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shop/providers/auth.dart';
import 'package:real_shop/screens/add_product_screen.dart';
import 'package:real_shop/screens/favorite_screen.dart';
import 'package:real_shop/screens/order_screen.dart';
import 'package:real_shop/screens/user_products_screen.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false ,
              title: Text('Hello Friends!'),
            ),
            Divider(),
            ListTile(
              title: Text('Shop'),
              leading: Icon(Icons.shop_rounded),
              onTap: ()=> Navigator.pushReplacementNamed(context, '/'),
            ),
            Divider(),
            ListTile(
              title: Text('Order'),
              leading: Icon(Icons.payment),
              onTap: ()=> Navigator.pushReplacementNamed(context, OrderScreen.rout),
            ),
            Divider(),
            ListTile(
              title: Text('Favorite Products'),
              leading: Icon(Icons.favorite),
              onTap: ()=> Navigator.pushReplacementNamed(context, FavoriteScreen.route),
            ),
            Divider(),
            ListTile(
              title: Text('Personal Products'),
              leading: Icon(Icons.person),
              onTap: ()=> Navigator.pushReplacementNamed(context, UserProductScreen.rout),
            ),
            Divider(),
            ListTile(
              title: Text('Add Products'),
              leading: Icon(Icons.add_box_rounded),
              onTap: ()=> Navigator.pushReplacementNamed(context, AddProductScreen.route),
            ),
            Divider(),
            ListTile(
              title: Text('Log Out'),
              leading: Icon(Icons.exit_to_app),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
                Provider.of<AuthProvider>(context, listen:  false ).logout();
              },
            ),

          ],
        ),
      ),
    );
  }
}
