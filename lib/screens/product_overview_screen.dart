
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shop/providers/cart.dart';
import 'package:real_shop/providers/products.dart';
import 'package:real_shop/screens/cart_screen.dart';
import 'package:real_shop/widgets/budge.dart';
import 'package:real_shop/widgets/product_grid_widget.dart';
import '/widgets/drawer_widget.dart';

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

enum ShopState{
  ShowAll , FavoriteOnly
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {

  bool _isLoading = false ;
  bool _showFavouriteProduct = false ;

  var shopState = ShopState.ShowAll ;
  @override
  void initState() {
    super.initState();
    Provider.of<ProductsProvider>(context,listen: false).getAllProduct().catchError((onError) {
      showDialog(context: context, builder: (_)=>AlertDialog(
        content: Text('Check connection with internet'),
      ));
    } ) ;
  }

  @override
  Widget build(BuildContext context) {
    var appBar =AppBar(
      title: Text('Shop'),
      actions: [
        PopupMenuButton(
          onSelected: (shopState){
            setState(() {
              if(shopState == ShopState.FavoriteOnly){
                _showFavouriteProduct = true ;
              }else{
                _showFavouriteProduct = false ;
              }
            });
          },
          itemBuilder: (ctx)=>[
            PopupMenuItem(child: Text('Only Favorite'),value: ShopState.FavoriteOnly,),
            PopupMenuItem(child: Text('Show All'),value: ShopState.ShowAll,),
          ],
        ),
        Consumer<CartProvider>(
          child: IconButton(
            onPressed:()=> Navigator.pushNamed(context, CartScreen.rout) ,
            icon: Icon(Icons.shopping_cart),
          ) ,
          builder: (_,value ,ch )=>BudgeWidget(child: ch ?? Container(), cartItemCounts: value.itemCount),
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      drawer: DrawerWidget(),
      body: _isLoading ? Center(child: CircularProgressIndicator(),):RefreshIndicator(
          onRefresh: () => Provider.of<ProductsProvider>(context,listen: false).getAllProduct() ,
          child: ProductGridWidget(_showFavouriteProduct)),
    );
  }
}
