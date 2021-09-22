import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shop/providers/cart.dart';
import 'package:real_shop/providers/orders.dart';

class CartScreen extends StatefulWidget {
  static const rout = '/cart_screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  bool _isLoading = false ;
  @override
  Widget build(BuildContext context) {
    var deviceSize  = MediaQuery.of(context).size ;
    var appBar = AppBar(
      title: Text('Cart'),
    );
    var cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: appBar ,
      body: Container(
        height:(deviceSize.height - MediaQuery.of(context).padding.top),
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 80 ,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        'Total Price',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Chip(
                        label: Text(
                            '\$ ${cartProvider.totalPrice.toStringAsFixed(2)}'),
                        backgroundColor: Theme.of(context).primaryColor,
                        labelStyle: TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      (_isLoading)? CircularProgressIndicator() :  FlatButton(
                          textColor: Theme.of(context).primaryColor,
                          onPressed: cartProvider.items.isEmpty? null : () {
                          try{
                            setState(() {
                              _isLoading = true ;
                            });
                              Provider.of<OrdersProvider>(context,listen: false).addOrder(
                              cartProvider.items.values.toList()  ,
                              cartProvider.totalPrice ,);
                            Provider.of<CartProvider>(context,listen: false).clearItem();
                            setState(() {
                              _isLoading = false ;
                            });
                          }catch(e){
                            setState(() {
                              _isLoading = false ;
                            });
                            print(e.toString());
                          }
                          },
                          child: Text('Order Now'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: deviceSize.height *.01,
            ),
            Expanded(
              child: cartProvider.items.isEmpty
                  ? Container()
                  : ListView.builder(
                      itemCount: cartProvider.itemCount,
                      itemBuilder: (ctx, index) => Dismissible(
                        background: Container(
                          alignment: Alignment.centerLeft,
                          color: Theme.of(context).errorColor,
                          child: Icon(Icons.delete),
                        ),
                        direction: DismissDirection.startToEnd,
                        confirmDismiss: (direction) {
                          return showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              content: Text(
                                  'Are you sure for deleting this item from cart'),
                              actions: [
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop(true);
                                    cartProvider.removeItem(cartProvider.items.keys.toList()[index]);
                                  },
                                  child: Text('Yes'),
                                ),
                                FlatButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: Text('No'),
                                ),
                              ],
                            ),
                          );
                        },
                        key: ValueKey(
                            cartProvider.items.values.toList()[index].id),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.green,
                            child: Text(
                              '\$ ${cartProvider.items.values.toList()[index].price}',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          title: Text(
                            cartProvider.items.values.toList()[index].title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              'Total ${cartProvider.items.values.toList()[index].quantity * cartProvider.items.values.toList()[index].price} \$'),
                          trailing: Text(
                              '${cartProvider.items.values.toList()[index].quantity} x'),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: ()=> cartProvider.clearItem(),
        child: Icon(Icons.remove_shopping_cart_rounded,color: Colors.white,),
      ),
    );
  }
}
