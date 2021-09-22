import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shop/modules/product.dart';
import 'package:real_shop/providers/products.dart';
import 'package:real_shop/screens/add_product_screen.dart';
import 'package:real_shop/widgets/drawer_widget.dart';

class UserProductScreen extends StatefulWidget {
  static const rout = '/user_product_screen';

  @override
  State<UserProductScreen> createState() => _UserProductScreenState();
}

class _UserProductScreenState extends State<UserProductScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;



  @override
  Widget build(BuildContext context) {

    Map<String,Product> items = Provider.of<ProductsProvider>(context).items ;
    List<Product> userProduct = [];
    items.values.toList().forEach((element) {
    if (element.creatorId == currentUser!.uid) {
    userProduct.add(element);
    }
    });
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: Text('User Products'),
      ),
      drawer: DrawerWidget(),
      body: userProduct.isEmpty?Center(child: Text('No Products'),): ListView.builder(
        itemCount: userProduct.length,
        itemBuilder: (_, index) => Stack(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.yellow.shade700,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    userProduct[index].title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${userProduct[index].price} \$',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  Text(
                    '${userProduct[index].description}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 200,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        userProduct[index].imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_,error , stackTree)=> Center(child: Text('Invalid Image URL')),
                      ),),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              left: 20 ,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                  borderRadius: BorderRadius.circular(25)
                ),
                child: IconButton(
                  color: Colors.yellowAccent,
                  icon: Icon(Icons.edit,),
                  onPressed: (){
                    WidgetsBinding.instance!.addPostFrameCallback((_){
                      Navigator.pushReplacementNamed(context, AddProductScreen.route,arguments:userProduct[index].id );
                    });
                  },
                ),
              ),
            ),
            Positioned(
              top: 20,
              right : 20 ,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25)
                ),
                child: IconButton(
                  color: Colors.yellowAccent,
                  icon: Icon(Icons.delete,),
                  onPressed: (){
                    Provider.of<ProductsProvider>(context,listen: false).removeProduct(userProduct[index].id??'');
                  },
                ),
              ),
            ),
          ],

        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.tealAccent.shade700,
          foregroundColor: Colors.black,
          onPressed: (){
            Navigator.pushNamed(context, AddProductScreen.route);
          },
          icon:Icon(Icons.add) ,
          label:Text('Add Product',style: TextStyle(fontWeight: FontWeight.w900),) ,
      ),
    );
  }
}
