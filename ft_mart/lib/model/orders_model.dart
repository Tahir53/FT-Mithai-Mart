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
  final String payment;
  final List<String> productNames;
  final List<String> quantities;
  final String? receiptImagePath;
  final String deviceToken;
  late String status; // New field for order status

  Order({
    required this.orderId,
    required this.cartItems,
    required this.totalAmount,
    required this.orderDateTime,
    required this.deliveryAddress,
    required this.name,
    required this.email,
    required this.contact,
    required this.payment,
    required this.productNames,
    required this.quantities,
    required this.receiptImagePath,
    required this.deviceToken,
    required this.status, // Initialize order status
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
      'payment': payment,
      'receiptImagePath': receiptImagePath,
      'deviceToken': deviceToken,
      'status': status, // Serialize order status
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
      payment: json['payment'],
      productNames: (json['productNames'] as List<dynamic>).cast<String>(),
      quantities: (json['quantities'] as List<dynamic>).cast<String>(),
      receiptImagePath: json['receiptImagePath'],
      deviceToken: json['deviceToken'],
      status: json['status'],
    );
  }

  static Set<String> generatedOrderIds = Set<String>();
  static String generateOrderId() {
    Random random = Random();
    String orderId;
    do {
      int randomNumber = random.nextInt(10000);
      orderId = randomNumber.toString().padLeft(4, '0');
    } while (generatedOrderIds.contains(orderId));
    generatedOrderIds.add(orderId);
    return orderId;
  }
}
