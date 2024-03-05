import 'package:intl/intl.dart';

import 'cart_model.dart';
import 'customer_model.dart';

class Order {
  final String orderId;
  final List<Cart> cartItems;
  final double totalAmount;
  final DateTime orderDateTime;
  final CustomerModel customer; // Add reference to CustomerModel
  final String? deliveryAddress;

  Order({
    required this.orderId,
    required this.cartItems,
    required this.totalAmount,
    required this.orderDateTime,
    required this.customer,
    this.deliveryAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'cartItems': cartItems.map((cart) => cart.toJson()).toList(),
      'totalAmount': totalAmount,
      'orderDateTime': DateFormat('yyyy-MM-dd HH:mm:ss').format(orderDateTime),
      'customer': customer.toJson(), // Convert customer to JSON
      'deliveryAddress': deliveryAddress,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      cartItems: (json['cartItems'] as List<dynamic>).map((item) =>
          Cart.fromJson(item)).toList(),
      totalAmount: json['totalAmount'],
      orderDateTime: DateFormat('yyyy-MM-dd HH:mm:ss').parse(
          json['orderDateTime']),
      customer: CustomerModel.fromJson(json['customer']),
      // Parse customer from JSON
      deliveryAddress: json['deliveryAddress'],
    );
  }
}