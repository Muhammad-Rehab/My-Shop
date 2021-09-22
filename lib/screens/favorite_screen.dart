import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shop/providers/products.dart';
import 'package:real_shop/widgets/drawer_widget.dart';

class FavoriteScreen extends StatefulWidget {
  static const route = '/favorite_screen';

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {

    final favoriteProduct =
        Provider.of<ProductsProvider>(context).favouriteItems;
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Screen'),
      ),
      drawer: DrawerWidget(),
      body: favoriteProduct.isEmpty
          ? Center(
              child: Text(
                'There Is No Product You Like It !',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            )
          : ListView.builder(
              itemCount: favoriteProduct.length,
              itemBuilder: (ctx, index) => Container(
                padding: EdgeInsets.only(bottom: 20),
                width: MediaQuery.of(context).size.width * .8,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.all(6),
                          height: 160,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              favoriteProduct.values.toList()[index].imageUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (_,error , stackTree)=> Center(child: Text('Invalid Image URL')),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          left: 5,
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.yellow,
                            child: Text(
                              '${favoriteProduct.values.toList()[index].price} \$',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: CircleAvatar(
                            backgroundColor: Colors.yellow,
                            child: IconButton(
                              color: Colors.black,
                              onPressed: () {
                                try {
                                  Provider.of<ProductsProvider>(context,listen: false)
                                      .toggleFavourite(
                                          true,
                                          favoriteProduct.keys.toList()[index]);
                                } catch (e) {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          content:
                                              Text('Unliked Processing Failed'),
                                        );
                                      });
                                }
                              },
                              icon: Icon(Icons.clear),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      favoriteProduct.values.toList()[index].title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Divider(),
                    Text(
                      favoriteProduct.values.toList()[index].description,
                      textAlign: TextAlign.center ,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
