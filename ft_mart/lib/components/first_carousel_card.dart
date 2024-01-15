import 'package:flutter/material.dart';

class FirstCarouselCard extends StatefulWidget {
  final ScrollController? scrollController;

  const FirstCarouselCard({this.scrollController});

  @override
  State<FirstCarouselCard> createState() => _FirstCarouselCardState();
}

class _FirstCarouselCardState extends State<FirstCarouselCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.92,
      height: 175.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: const Color(0xFFFFC937), // Background color
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Want to send a "sweet"',
              style: TextStyle(
                  fontSize: 18.0,
                  color: Color(0xFF212121),
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8.0), // Add some space
            Text(
              'gift to someone?',
              style: TextStyle(
                  fontSize: 18.0,
                  color: Color(0xFF212121),
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20.0), // Add more space
            Text(
              'We are here to help!',
              style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Row(
              children: [
                Container(
                  child: TextButton(
                    onPressed: () {
                      // Scroll down when the "Get started" button is pressed
                      widget.scrollController?.animateTo(
                        widget.scrollController?.position.maxScrollExtent ?? 0,
                        duration: Duration(seconds: 1),
                        curve: Curves.easeOutSine,
                      );
                    },
                    child: Text(
                      'Get started',
                      style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_sharp)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
