import 'package:flutter/cupertino.dart';

class Product {
  final String ? id;

  final String? creatorId;

  final String title;

  final String description;

  final double price;

  final String imageUrl;

  bool isFavorite;

  Product({
     this.id,
    this.creatorId,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });
}
