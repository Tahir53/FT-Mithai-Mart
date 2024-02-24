import 'package:flutter/material.dart';

class CategoryContainer extends StatelessWidget {
  CategoryContainer(
      {super.key, required this.categoryName, this.selected = false});

  final String categoryName;
  bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      width: 180.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF801924) : const Color(0xFFFFF8E6),
        // Background color
        borderRadius: BorderRadius.circular(10.0), // Circular border radius
      ),
      child: Center(
        child: Text(
          categoryName,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black, // Text color
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
