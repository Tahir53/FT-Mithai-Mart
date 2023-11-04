


import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E6), 
          borderRadius: BorderRadius.circular(8.0),
        ),
        child:  Padding(
          padding:  EdgeInsets.symmetric(horizontal: 15),
          child:  TextField(
            onChanged: (a){
              
            },
            style: TextStyle(
              fontFamily: 'Montserrat', 
            ),
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(
                color: Color(0xFF6B4F02), 
              ),
              suffixIcon: Icon(
                Icons.search,
                color: Color(0xFF6B4F02), 
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}