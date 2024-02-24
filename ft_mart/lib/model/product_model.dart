import 'package:mongo_dart/mongo_dart.dart';

class Product {
  ObjectId? id;
  List<double> quantity;
  String name;
  String price;
  String image;
  double stock;
  String category;
  String description;

  Product({
    this.id,
    required this.quantity,
    required this.name,
    required this.price,
    required this.image,
    required this.stock,
    required this.category,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      quantity: List<double>.from(json['quantity']),
      id: json['_id'],
      name: json['name'],
      price: json['price'],
      image: json['image'],
      stock: json['stock'].toDouble(),
      category: json['category'],
      description: json['description'],
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
    };
  }
}
