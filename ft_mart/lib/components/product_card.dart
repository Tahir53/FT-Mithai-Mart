import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  ProductCard({
    Key? key,
    required this.assetPath,
    required this.productName,
    required this.price,
    required this.discount, // Add this line
    this.onTap,
  }) : super(key: key);

  final String assetPath;
  final String productName;
  final int price;
  final double discount; // Add this line
  Function(String, String, double)? onTap;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  double selectedWeight = 1.0;

  @override
  Widget build(BuildContext context) {
    double discountedPrice = widget.price * (1 - widget.discount / 100);

    return SingleChildScrollView(
      child: SizedBox(
        width: 180,
        height: 280,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: const Color(0xFFFFF8E6),
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
                          color: Color(0xFF212121),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Rs. ${widget.price.toString()}/kg',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: const Color(0xFF212121),
                              decoration: widget.discount > 0
                                  ? TextDecoration.lineThrough
                                  : null,
                              decorationColor: const Color(0xFF63131C),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.discount > 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rs. ${discountedPrice.toStringAsFixed(0)}/kg',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Color(0xFF212121),
                            ),
                          ),
                          Text(
                            '${widget.discount.toString()}% off',
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF63131C),
                            ),
                          ),
                        ],
                      ),
                  ],
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
      color: const Color(0xFFFFF8E6),
      onSelected: (value) {
        setState(() {
          selectedWeight = value;
        });

        num calculatedPrice = value == 0.5 ? widget.price * 0.5 : widget.price;
        double discountedPrice = calculatedPrice * (1 - widget.discount / 100);

        if (widget.onTap != null) {
          widget.onTap!(
            widget.productName,
            discountedPrice.toStringAsFixed(0), // Pass the discounted price
            selectedWeight,
          );
        }
      },
      itemBuilder: (BuildContext context) {
        return [1.0, 0.5].map((double choice) {
          num calculatedPrice =
              choice == 0.5 ? widget.price * 0.5 : widget.price;
          double discountedPrice =
              calculatedPrice * (1 - widget.discount / 100);

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
                          decoration: widget.discount > 0
                              ? TextDecoration.lineThrough
                              : null,
                          color: const Color(0xFF63131C),
                          fontSize: 15,
                        ),
                      ),
                      if (widget.discount > 0)
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
