import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shop/modules/orders.dart';
import 'package:real_shop/providers/orders.dart';
import '/widgets/drawer_widget.dart';


class OrderScreen extends StatefulWidget {
  static const rout = '/order_screen';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    Provider.of<OrdersProvider>(context,listen: false).getOrders();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    Map<String, OrderItems> orderItem =
        Provider.of<OrdersProvider>(context).order;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order'),
      ) ,
      drawer: DrawerWidget(),
      body: orderItem.isEmpty
          ? Center(child: Text('No Orders',style: TextStyle(fontSize: 24),))
          : ListView.builder(
              itemCount: orderItem.length,
              itemBuilder: (_, index) => Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.yellow.shade300,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'Order ${index + 1}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Created At ${orderItem.values.toList()[index].dateTime}',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Total ${orderItem.values.toList()[index].amount.toStringAsFixed(2)} \$',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Column(
                      children:
                          orderItem.values.toList()[index].products.map((e) {
                        return ListTile(
                          trailing: CircleAvatar(
                            backgroundColor: Colors.tealAccent,
                            child: Text(
                              '${e.quantity} x',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            e.title,
                            style: TextStyle(
                              color: Colors.blue.shade900,
                            ),
                          ),
                          subtitle: Text(
                            '\$  ${e.price}',
                            style: TextStyle(
                              color: Colors.orange.shade900,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Divider(
                      height: 10,
                      thickness: 2,
                    ),
                    FlatButton.icon(
                      color: Colors.yellow.shade900,
                      onPressed: () {
                        Provider.of<OrdersProvider>(context, listen: false)
                            .deleteOrder(orderItem.values.toList()[index].id);
                      },
                      icon: Icon(Icons.delete),
                      label: Text('Delete Order !'),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
