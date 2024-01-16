import 'dart:ffi';

import 'package:flutter/material.dart';

import '../model/product_model.dart';

class ProductCard extends StatefulWidget {
  ProductCard(
      {Key? key,
      required this.assetPath,
      required this.productName,
      required this.price,
      this.onTap})
      : super(key: key);

  final String assetPath;
  final String productName;
  final int price;
  Function(String, String, double)? onTap;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  double selectedWeight = 1.0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 180,
        height: 280,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10.0,
            ), // Half of the width or height to make it circular
          ),
          color: const Color(0xFFFFF8E6), // Background color of the card
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Image.network(
                    widget.assetPath,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.productName,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121), // Text color
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: buildPopupMenuButton(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  'Rs. ${widget.price.toString()}/kg',
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFF212121), // Text color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPopupMenuButton() {
    return PopupMenuButton<double>(
      color: Color(0xFFFFF8E6),
      onSelected: (value) {
        setState(() {
          selectedWeight = value;
        });

        // Calculate the price based on the selected weight
        num calculatedPrice = value == 0.5 ? widget.price * 0.5 : widget.price;

        // Add the item to the cart
        if (widget.onTap != null) {
          widget.onTap!(
            widget.productName,
            calculatedPrice.toString(),
            selectedWeight,
          );
        }
      },
      itemBuilder: (BuildContext context) {
        return [1.0, 0.5].map((double choice) {
          // Calculate the price for each choice
          num calculatedPrice = choice == 0.5 ? widget.price * 0.5 : widget.price;

          return PopupMenuItem<double>(
            value: choice,
            child: Container(
              decoration: BoxDecoration(
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
                    style: TextStyle(
                      color: Color(0xFF63131C),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  // Displaying the calculated price
                  Text(
                    'Rs.${calculatedPrice.toString()}',
                    style: TextStyle(
                      color: Color(0xFF63131C),
                      fontSize: 15,
                    ),
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
            Icons.add,
            color: Colors.black,
            size: 28,
          ),
          Container(
            padding: const EdgeInsets.only(left: 7),
            width: 40,
            child: const Text(
              'Add to Cart',
              style: TextStyle(
                fontSize: 8.0,
                color: Color(0xFF212121),
              ),
            ),
          ),
        ],
      ),
    );
  }


}
