import 'package:flutter/cupertino.dart';

class SecondCarouselCard extends StatelessWidget {
  final ScrollController? scrollController;

  SecondCarouselCard({this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.92,
      height: 175.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.network(
          'https://i.ibb.co/T4mG6kN/mithai-sweets-eid-celebration-photography-260nw-2279282763.jpg', // Replace with your image URL
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}