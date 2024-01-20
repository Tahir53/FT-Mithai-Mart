import 'package:flutter/material.dart';

class CartItemTile extends StatelessWidget {
  final String productName;
  final String formattedQuantity;
  final String price;
  final Function onTapDelete;

  const CartItemTile({
    Key? key,
    required this.productName,
    required this.formattedQuantity,
    required this.price,
    required this.onTapDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xff801924),
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
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 40),
            Expanded(
              child: Text(
                '$formattedQuantity kgs',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Text(
              'Rs.$price',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(width: 10),
            GestureDetector(
              onTap: () => onTapDelete(),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
