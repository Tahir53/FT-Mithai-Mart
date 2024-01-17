class Cart {
  final String productName;
  final String price;
  late final double quantity;

  Cart({
    required this.productName,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'price': price,
      'quantity': quantity,
    };
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      productName: json['productName'],
      price: json['price'],
      quantity: json['quantity'].toDouble(),
    );
  }
}