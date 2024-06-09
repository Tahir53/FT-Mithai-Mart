import 'package:flutter/material.dart';

class MessageTextField extends StatefulWidget {
  final TextEditingController controller;

  const MessageTextField({Key? key, required this.controller})
      : super(key: key);

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  double textFieldHeight = 46.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.70, //304.0,
      height: textFieldHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
        ),
      ),
      child: TextField(
        controller: widget.controller,
        onChanged: (text) {
          int numLines = (text.length / 30).ceil();
          setState(() {
            textFieldHeight = 30.0 + numLines * 20.0;
          });
        },
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
        maxLines: null,
        decoration: const InputDecoration(
          hintText: 'Type your message here ...',
          hintStyle: TextStyle(color: Colors.black, fontSize: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
