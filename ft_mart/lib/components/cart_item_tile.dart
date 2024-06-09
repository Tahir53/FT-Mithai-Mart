import 'package:flutter/material.dart';

class CartItemTile extends StatelessWidget {
  final String productName;
  final String formattedQuantity;
  final String price;
  final bool showDeleteIcon; // New parameter to control delete icon visibility
  final Function onTapDelete;

  const CartItemTile({
    Key? key,
    required this.productName,
    required this.formattedQuantity,
    required this.price,
    required this.showDeleteIcon, // Initialize the new parameter
    required this.onTapDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xff801924),
      elevation: 5,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Text(
                productName,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 40),
            Expanded(
              child: Text(
                '$formattedQuantity kgs',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Text(
              'Rs.$price',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(width: 10),
            if (showDeleteIcon) // Conditionally show delete icon
              GestureDetector(
                onTap: () => onTapDelete(),
                child: const Icon(
                  Icons.remove_circle_outline_rounded,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}