import 'package:intl/intl.dart';
import 'dart:math';
import 'cart_model.dart';

class Order {
  final String orderId;
  final List<Cart> cartItems;
  final double totalAmount;
  final DateTime orderDateTime;
  final String? deliveryAddress;
  final String name;
  final String email;
  final String contact;
  final List<String> productNames;
  final List<String> quantities;

  Order({
    required this.orderId,
    required this.cartItems,
    required this.totalAmount,
    required this.orderDateTime,
    required this.deliveryAddress,
    required this.name,
    required this.email,
    required this.contact,
    required this.productNames,
    required this.quantities,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'name': name,
      'email': email,
      'contact': contact,
      'cartItems': cartItems.map((cart) => cart.toJson()).toList(),
      'totalAmount': totalAmount,
      'orderDateTime': DateFormat('yyyy-MM-dd HH:mm:ss').format(orderDateTime),
      'deliveryAddress': deliveryAddress,
      'productNames': productNames,
      'quantities': quantities,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      name: json['name'],
      email: json['email'],
      contact: json['contact'],
      cartItems: (json['cartItems'] as List<dynamic>).map((item) => Cart.fromJson(item)).toList(),
      totalAmount: json['totalAmount'],
      orderDateTime: DateFormat('yyyy-MM-dd HH:mm:ss').parse(json['orderDateTime']),
      deliveryAddress: json['deliveryAddress'],
      productNames: (json['productNames'] as List<dynamic>).cast<String>(),
      quantities: (json['quantities'] as List<dynamic>).cast<String>(),
    );
  }
  static Set<String> generatedOrderIds = Set<String>();
  static String generateOrderId() {
    Random random = Random();
    String orderId;
    do {
      int randomNumber = random.nextInt(10000); // Generate a random number between 0 and 9999
      orderId = randomNumber.toString().padLeft(4, '0'); // Ensure the order ID is exactly 4 digits long
    } while (generatedOrderIds.contains(orderId)); // Repeat if the generated order ID already exists
    generatedOrderIds.add(orderId); // Add the generated order ID to the set
    return orderId;
  }
}
