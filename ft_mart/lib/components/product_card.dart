import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.assetPath, required this.productName, required this.price});
  final String assetPath;
  final String productName;
  final int price;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 180,
        height: 280,
        child: Card(
          shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0), // Half of the width or height to make it circular
  ),
          color: const Color(0xFFFFF8E6), // Background color of the card
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    assetPath,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding:  const EdgeInsets.only(left: 10.0, right: 0,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        productName,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121), // Text color
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.add,
                            size: 32,
                            color: Color(0xFF212121), // Icon color
                          ),
                          const SizedBox(height: 5,),
                          Container(
                            padding: const EdgeInsets.only(left: 7),
                            width: 40,
                            child: const Text(
                              'Add to Cart',
                              style: TextStyle(
                                fontSize: 8.0,
                                color: Color(0xFF212121), // Text color
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  'Rs. ${price.toString()}/kg',
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
}
