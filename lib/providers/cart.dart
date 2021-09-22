import 'package:flutter/material.dart';
import 'package:real_shop/modules/cart.dart';


class CartProvider extends ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return _items;
  }

  int get itemCount {
    return _items.length;
  }

  double get totalPrice {
    double total = 0 ;
    _items.forEach((key, cartItem) {
      total = total + (cartItem.quantity * cartItem.price);
    });
    return total;
  }

  void addItem(String prodID, String title, double price) {
    if (_items.containsKey(prodID)) {
      _items.update(
          prodID,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                quantity: existingCartItem.quantity + 1,
                price: existingCartItem.price,
              ));
    } else {
      _items.addAll({
      prodID : CartItem(
      id: prodID,
      title: title,
      quantity: 1,
      price: price,
      )
      });
    }
    notifyListeners();
  }

  removeItem(prodId) {
    _items.remove(prodId);
    notifyListeners();
  }

  removeSingleItem(String prodId) {
    if (!_items.containsKey(prodId)) {
      return;
    }
    if (_items[prodId]!.quantity > 1) {
      _items.update(
          prodId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                quantity: existingCartItem.quantity - 1,
                price: existingCartItem.price,
              ));
    } else {
      _items.remove(prodId);
    }
    notifyListeners();
  }

  toggleItem(String prodID, String title, double price ) {
      if (_items.containsKey(prodID)) {
      if(_items[prodID]!.quantity >= 1){
        addItem(prodID, title, price);
      }else{
        removeSingleItem(prodID);
      }
    } else {
      addItem(prodID, title, price);
    }
  }

  clearItem() {
    _items.clear();
    notifyListeners();
  }
}
