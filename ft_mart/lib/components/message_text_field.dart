import 'package:flutter/material.dart';

class MessageTextField extends StatelessWidget {
  final TextEditingController controller;

  const MessageTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.73, //304.0,
      height: MediaQuery.of(context).size.height * 0.049, //46.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.029),
        child: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.black, fontSize: 14),
          decoration: const InputDecoration(
            hintText: 'Type your message here ...',
            hintStyle: TextStyle(color: Colors.black, fontSize: 14),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}