import 'package:flutter/material.dart';

class SearchDataField extends StatelessWidget {
  final String name;
  final String category;
  final String price;
  final String image;
  final double stock;
  final Function(String name, String price, double stock) onPopupMenuButtonPressed;

  const SearchDataField({
    Key? key,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
    required this.stock,
    required this.onPopupMenuButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        color: Color(0xFF63131C),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
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
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Category: $category',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Price: Rs.$price/kg',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Tap For Description',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.network(
                        image,
                        width: 80,
                        height: 100,
                      ),
                      SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: buildPopupMenuButton(name, int.parse(price)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

 Widget buildPopupMenuButton(String product, int price) {
    return PopupMenuButton<double>(
      color: Color(0xFFFFF8E6),
      onSelected: (value) {
        num calculatedPrice = value == 0.5 ? price * 0.5 : price;
        onPopupMenuButtonPressed(product, calculatedPrice.toString(), value);
      },
      itemBuilder: (BuildContext context) {
        return [1.0, 0.5].map((double choice) {
          // Calculate the price for each choice
          num calculatedPrice = choice == 0.5 ? price * 0.5 : price;

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
                  // Displaying the calculated price
                  Text(
                    'Rs.${calculatedPrice.toString()}',
                    style: const TextStyle(
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
                color: Color(0xFF212121),
              ),
            ),
          ),
        ],
      ),
    );
  }

}



