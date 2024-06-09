import 'package:flutter/material.dart';

class SearchDataField extends StatelessWidget {
  final String name;
  final String category;
  final String price;
  final String image;
  final double stock;
  final String description;
  final double discount; // Add this line
  final Function(String name, String price, double stock)
      onPopupMenuButtonPressed;

  const SearchDataField({
    Key? key,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
    required this.stock,
    required this.description,
    required this.discount, // Add this line
    required this.onPopupMenuButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showProductDialog(context);
      },
      child: Card(
        color: const Color(0xFF63131C),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              image,
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Category: $category',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Price: Rs.$price/kg',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Tap For Description',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: buildPopupMenuButton(
                            name, int.parse(price), discount),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPopupMenuButton(String product, int price, double discount) {
    return PopupMenuButton<double>(
      color: const Color(0xFFFFF8E6),
      onSelected: (value) {
        num calculatedPrice = value == 0.5 ? price * 0.5 : price;
        double discountedPrice = calculatedPrice * (1 - discount / 100);
        onPopupMenuButtonPressed(
            product, discountedPrice.toStringAsFixed(0), value);
      },
      itemBuilder: (BuildContext context) {
        return [1.0, 0.5].map((double choice) {
          // Calculating the price for each choice
          num calculatedPrice = choice == 0.5 ? price * 0.5 : price;
          double discountedPrice = calculatedPrice * (1 - discount / 100);

          return PopupMenuItem<double>(
            value: choice,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFF63131C),
                    width: 2.0,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$choice kg',
                    style: const TextStyle(
                      color: Color(0xFF63131C),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Original: ',
                        style: TextStyle(
                          color: Color(0xFF63131C),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Rs.${calculatedPrice.truncate()}',
                        style: TextStyle(
                          decoration:
                              discount > 0 ? TextDecoration.lineThrough : null,
                          color: const Color(0xFF63131C),
                          fontSize: 15,
                        ),
                      ),
                      if (discount > 0)
                        Text(
                          'Discounted: Rs.${discountedPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Color(0xFF63131C),
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList();
      },
      child: Column(
        children: [
          const Icon(
            Icons.add_shopping_cart,
            color: Colors.white,
            size: 28,
          ),
          Container(
            padding: const EdgeInsets.only(left: 7),
            width: 40,
            child: const Text(
              'Add to Cart',
              style: TextStyle(
                fontSize: 8.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF63131C),
          title: Text(
            name,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            description,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
