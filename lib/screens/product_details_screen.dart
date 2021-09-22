import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shop/providers/products.dart';


class ProductDetailsScreen extends StatelessWidget {
  static const rout = '/product_detail_screen';

  @override
  Widget build(BuildContext context) {
    final productFeatures = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final loadedProduct = Provider.of<ProductsProvider>(context, listen: false)
        .items.values.toList()
        .firstWhere((element) => element.id == productFeatures['id']);
    return Hero(
      tag: loadedProduct.id.toString(),
      child: Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: ()=> Navigator.pushReplacementNamed(context, '/'),
        ),
      ),
      // drawer: DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child:  Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    expandedHeight: 300,
                    pinned: true,
                    backgroundColor: Colors.orange,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.network(
                        loadedProduct.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_,error , stackTree)=> Center(child: Text('Invalid Image URL')),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          loadedProduct.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 26,
                              fontWeight: FontWeight.bold),
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                        Text(
                          '${loadedProduct.price} \$',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: 18,
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Text(
                            loadedProduct.description,
                            overflow: TextOverflow.fade,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 20,
                right: 15,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.yellow ,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Provider.of<ProductsProvider>(context,listen: false )
                          .toggleFavourite( false,productFeatures['id']);
                    },
                    icon : Consumer<ProductsProvider>(
                      builder: (_,productPro,ch)=>  Icon(
                          productPro.items.values.toList()[productFeatures['index']].isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.black,),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
