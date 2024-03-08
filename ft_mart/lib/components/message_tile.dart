import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {

  AlignmentGeometry alignment;
  MessageTile({this.alignment = Alignment.topLeft});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              "hello",
              style: TextStyle(
                color: Color(0xff801924),
              ),
            ),
          ),
        ],
      ),
    );
  }
}