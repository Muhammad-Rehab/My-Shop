import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '/modules/product.dart';

class ProductsProvider extends ChangeNotifier {

  Map<String, Product> _items = {
    // Product(
    //   id: 'p1',
    //   creatorId: 'pz1SwGs0mhS5dFN0UYQIm3AmxUA2',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //   'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   creatorId: 'pz1SwGs0mhS5dFN0UYQIm3AmxUA2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   creatorId: 'pz1SwGs0mhS5dFN0UYQIm3AmxUA2',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //   'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   creatorId: 'pz1SwGs0mhS5dFN0UYQIm3AmxUA2',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  };
  Map<String, Product> _favouriteItems = {};
  DatabaseReference database = FirebaseDatabase.instance.reference();
  User? _currentUser = FirebaseAuth.instance.currentUser ;
  Map<String, Product> get items {
    return _items;
  }
  Map<String, Product> get favouriteItems {
    return _favouriteItems;
  }


  isFavourite( String id) async {
    try {
      _items[id]!.isFavorite = true;
      await database.child('favorites/${_currentUser!.uid}').update({
        '$id': _items[id]!
            .isFavorite,
      });
      _favouriteItems.putIfAbsent(
          id, () => _items.values.toList().firstWhere((element) => element.id==id));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  toggleFavourite( bool favouritePage, String id) async {
    if (favouritePage) {
      await database
          .child('favorites/${_currentUser!.uid}/$id')
          .remove();
      _favouriteItems[id]!.isFavorite = false ;
      _favouriteItems.remove(id);
    } else {
      if (_items[id]!.isFavorite == false) {
        isFavourite(id);
      } else {
        _items[id]!.isFavorite = false;
        await database
            .child(
            'favorites/${_currentUser!.uid}/${_items[id]!.id}')
            .remove();
        if (_favouriteItems.containsKey(id)) {
          _favouriteItems.remove(id);
        }
      }
    }

    notifyListeners();
  }

  getAllProduct() async {
    _currentUser = FirebaseAuth.instance.currentUser ;
    _items.clear();
    _favouriteItems.clear();
  try {
    var  data = ( (await database.child('products').get()).value ?? {}) as Map ;
    var favData = ((await database.child('favorites/${_currentUser!.uid}').get()).value ??{} ) as Map ;
     if(data.isNotEmpty){
       data.forEach((key, currentProduct) {_items.putIfAbsent(key, () => Product(
           id: key ,
           creatorId: currentProduct['creatorId'],
           title: currentProduct['title'],
           description: currentProduct['description'],
           price: double.parse(currentProduct['price'].toString()),
           imageUrl: currentProduct['imageUrl'],
         ));});
       if(favData.isNotEmpty){
         favData.forEach((key, value) {
           _items[key]!.isFavorite = true ;
           _favouriteItems.putIfAbsent(key, () => Product(
             id: key ,
             creatorId: _items[key]!.creatorId   ,
             title: _items[key]!.title ,
             description: _items[key]!.description ,
             price:  _items[key]!.price ,
             imageUrl:  _items[key]!.imageUrl,
             isFavorite: _items[key]!.isFavorite ,
           ));
         });
       }else{
         _items.forEach((key, value) {
           value.isFavorite = false ;
         });
       }
     }
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

   getOneProduct(String id)  {
    try {

      notifyListeners();
      return _items[id];

    } catch (e) {
      throw e;
    }
  }

  addProduct(Product product) async {
    try {
      DatabaseReference res = database.child('products').push();
      await res.set({
        'creatorId': FirebaseAuth.instance.currentUser!.uid,
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl.toString(),
      });
      _items.putIfAbsent(res.key, () => Product(
          id: res.key,
          creatorId: FirebaseAuth.instance.currentUser!.uid,
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          isFavorite: product.isFavorite));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  removeProduct(String id) async {
    try {
      await database.child('products/$id').remove();
      if(_favouriteItems.containsKey(id)){
        _favouriteItems.remove(id);
      }
      _items.remove(id);
      notifyListeners();
    } catch (e) {
      // await FirebaseDatabase.instance.reference().child('products').set(oldProduct);
      throw e;
    }
  }

  updateProduct(String id, Product product) async {
    try {
      await database.child('products/$id').update({
        'creatorId': FirebaseAuth.instance.currentUser!.uid,
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'isFavorite': true,
      });
      _items.update(id, (value) => product);
      if(_favouriteItems.containsKey(id)){
        _favouriteItems.update(id, (value) => product);
      }
      notifyListeners();
    } catch (e) {
      print(e);

    }
  }

  clearProduct() async {
    await database.child('products').remove();
    _items.clear();
    notifyListeners();
  }


}
