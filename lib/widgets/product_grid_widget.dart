import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:real_shop/modules/product.dart';
import 'package:real_shop/providers/cart.dart';
import 'package:real_shop/providers/products.dart';
import 'package:real_shop/screens/product_details_screen.dart';
import 'package:animated_icon_button/animated_icon_button.dart';

class ProductGridWidget extends StatefulWidget {
  bool _showOnlyFavorite;

  ProductGridWidget(this._showOnlyFavorite);

  @override
  State<ProductGridWidget> createState() => _ProductGridWidgetState();
}

class _ProductGridWidgetState extends State<ProductGridWidget> {
  Color ? _likedButtonColor ;
  @override
  Widget build(BuildContext context) {

    Map<String, Product> loadedProducts = widget._showOnlyFavorite
        ? Provider
        .of<ProductsProvider>(
      context,
    )
        .favouriteItems
        : Provider
        .of<ProductsProvider>(
      context,
    )
        .items;

    if (loadedProducts.isEmpty) {
      return Center(
        child: Text(
          'No Item Here',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
      );
    } else {
      return GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: loadedProducts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, index) {
            loadedProducts.values.toList()[index].isFavorite?_likedButtonColor=Colors.red:_likedButtonColor=Colors.grey;
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GestureDetector(
              onTap: () =>
                  Navigator.pushReplacementNamed(
                      ctx, ProductDetailsScreen.rout,
                      arguments: {
                        'id': loadedProducts.values.toList()[index].id,
                        'index': index,
                      }),
              child: Hero(
                tag: loadedProducts.keys.toList()[index].toString(),
                child: GridTile(
                  child: FadeInImage(
                    imageErrorBuilder: (_, error, stackTree) =>
                        Center(child: Text('Invalid Image URL')),
                    placeholder:AssetImage('assets/images/product-placeholder.png'),
                    image: NetworkImage(loadedProducts.values.toList()[index].imageUrl),
                    fit: BoxFit.contain,
                  ),
                  footer: GridTileBar(
                    backgroundColor: Colors.black87,
                    leading:
                    AnimatedIconButton(
                      icons: [
                        AnimatedIconItem(
                          icon: Icon(
                            Icons.favorite,
                            color: _likedButtonColor,
                          ),
                        ),
                      ],
                      duration: Duration(milliseconds: 300),
                      onPressed: () {
                        if(loadedProducts.values.toList()[index].isFavorite){
                          setState(() {
                            _likedButtonColor=Colors.red ;
                          });
                        }else{
                          setState(() {
                            _likedButtonColor=Colors.grey;
                          });
                        }
                        Provider.of<ProductsProvider>(
                            context, listen: false)
                            .toggleFavourite(
                            false, loadedProducts.keys.toList()[index]);
                      },
                      size: 25 ,
                    ),
                    title: Text(
                      loadedProducts.values.toList()[index].title,
                      style: TextStyle(
                        color: Colors.yellow,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    trailing: Consumer<CartProvider>(
                      builder: (ctx, cartProvider, child) =>
                          IconButton(
                            color: Colors.red,
                            icon: Icon(cartProvider.items.containsKey(
                                loadedProducts.values.toList()[index].id)
                                ? Icons.shopping_cart
                                : Icons.shopping_cart_outlined),
                            onPressed: () {
                              cartProvider.toggleItem(
                                loadedProducts.values.toList()[index].id ??
                                    '',
                                loadedProducts.values.toList()[index].title,
                                loadedProducts.values.toList()[index].price,
                              );
                              Scaffold.of(ctx).hideCurrentSnackBar();
                              showDialog(
                                context: ctx,
                                builder: (_) =>
                                    AlertDialog(
                                      title: Text(
                                        'Determine Quantity !',
                                        style: TextStyle(
                                            color: Colors.yellow),
                                      ),
                                      content: Container(
                                        child: ListTile(
                                          leading: IconButton(
                                            onPressed: () {
                                              cartProvider.toggleItem(
                                                loadedProducts.values
                                                    .toList()[index]
                                                    .id ??
                                                    '',
                                                loadedProducts.values
                                                    .toList()[index]
                                                    .title,
                                                loadedProducts.values
                                                    .toList()[index]
                                                    .price,
                                              );
                                            },
                                            icon: Icon(Icons
                                                .keyboard_arrow_up_outlined),
                                          ),
                                          title: IconButton(
                                            onPressed: () {
                                              cartProvider.removeSingleItem(
                                                  loadedProducts
                                                      .values
                                                      .toList()[index]
                                                      .id ??
                                                      '');
                                            },
                                            icon:
                                            Icon(Icons
                                                .keyboard_arrow_down_outlined),
                                          ),
                                          trailing: Consumer<CartProvider>(
                                            builder: (_, cartPro, child) =>
                                                Text(
                                                  (cartPro
                                                      .items[loadedProducts
                                                      .values
                                                      .toList()[index]
                                                      .id] ==
                                                      null)
                                                      ? '0'
                                                      : '${cartPro
                                                      .items[loadedProducts
                                                      .values.toList()[index]
                                                      .id]!.quantity}',
                                                  style: TextStyle(
                                                    color: Colors.yellow,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        FlatButton(
                                          textColor: Colors.greenAccent,
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                          },
                                          child: Text('Okay !'),
                                        )
                                      ],
                                    ),
                              );
                            },
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ) ;
        }
      );
    }
  }
}
