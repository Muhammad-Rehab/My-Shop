
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:real_shop/modules/cart.dart';
import 'package:real_shop/modules/orders.dart';

class OrdersProvider extends ChangeNotifier {

  Map<String ,OrderItems> _orders = {};
  User? currentUser = FirebaseAuth.instance.currentUser;
  var database = FirebaseDatabase.instance.reference();

  Map<String ,OrderItems> get order {
    return _orders;
  }

  getOrders() async {
    currentUser = FirebaseAuth.instance.currentUser;
    _orders.clear();
    Map res = ((await database.child('orders/${currentUser!.uid}').get()).value ??{}) as Map;
    res.forEach((key, value) {
      _orders.putIfAbsent(key ,()=> OrderItems(
        id: key,
        amount: double.parse(value['amount'].toString()),
        dateTime: DateTime.parse(value['dateTime']),
        products: List.generate(
            value['products'].length,
            (index) => CartItem(
                id: value['products'][index]['id'] ,
                title: value['products'][index]['title'],
                quantity:value['products'][index]['quantity'],
                price: double.parse(value['products'][index]['price'].toString()),
            )),
      ));
    });

    notifyListeners();
  }

  addOrder(List<CartItem> cartProduct, double total) async {
    currentUser = FirebaseAuth.instance.currentUser;
    try {
      var res = database.child('orders/${currentUser!.uid}').push();
      await res.set({
        'amount': total,
        'dateTime': DateTime.now().toIso8601String(),
        'products': cartProduct.map((cartItem) {
          return {
            'id': cartItem.id,
            'title': cartItem.title,
            'quantity': cartItem.quantity,
            'price': cartItem.price,
          };
        }).toList(),
      });

      _orders.addAll(
        {
          res.key :
          OrderItems(
            id: res.key,
            amount: total,
            products: cartProduct,
            dateTime: DateTime.now(),
          )
        });
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  deleteOrder(String id) async {
    try{
     await database.child('orders/${currentUser!.uid}/$id').remove();
     _orders.remove(id);
    }catch(e){
      throw e;
    }
    notifyListeners();
  }

}
