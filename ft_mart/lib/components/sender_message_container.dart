import 'package:flutter/material.dart';

class SenderMessageContainer extends StatelessWidget {
  final String message;
  final String timestamp;

  const SenderMessageContainer({
    super.key,
    required this.message,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Circle Avatar on the left
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF6FE170),
            ),
            child: const Center(
              child: Text(
                "FT", // Display initials or user icon
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Add spacing between avatar and message container
          // Message Container on the right
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.6,
            ),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xff801924),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                // Add spacing between message and timestamp
                Text(
                  timestamp,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
