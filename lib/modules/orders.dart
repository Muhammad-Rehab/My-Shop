import 'cart.dart';

class OrderItems {

  final String id;
  final double amount;
  final List<CartItem> products ;
  final DateTime dateTime ;

  OrderItems({
    required this.id,
    required this.amount,
    required this.dateTime ,
    required this.products,
  });
}
