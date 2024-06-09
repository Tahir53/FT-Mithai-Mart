import 'package:mongo_dart/mongo_dart.dart';

class Product {
  ObjectId? id;
  String name;
  String price;
  double stock;
  String category;
  String image;
  List<double> quantity;
  String description;
  double? discount;
  String discountedPrice;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
    required this.image,
    required this.quantity,
    required this.description,
    required this.discount,
    required this.discountedPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      quantity: List<double>.from(json['quantity']),
      id: json['_id'],
      name: json['name'],
      price: json['price'].toString(),
      image: json['image'],
      stock: json['stock'].toDouble(),
      category: json['category'],
      description: json['description'],
      discount: json['discount']?.toDouble(),
      discountedPrice: json['discountedPrice'] ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'quantity': quantity,
      'name': name,
      'price': price,
      'image': image,
      'stock': stock,
      'category': category,
      'description': description,
      'discount': discount,
      'discountedPrice': discountedPrice,
    };
  }
}
