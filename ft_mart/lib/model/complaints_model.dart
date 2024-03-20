import 'dart:math';

import 'package:mongo_dart/mongo_dart.dart';

class Complaint {
  ObjectId? id;
  late String name;
  late String email;
  late String contact;
  late String description;
  late String complaintId;

  Complaint(
      {this.id,
        required this.name,
        required this.email,
        required this.contact,
        required this.description,
        required this.complaintId});

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      contact: json['contact'],
      description: json['description'],
      complaintId: json['complaintId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'contact': contact,
      'description': description,
      'complaintId': complaintId,
    };
  }

  static Set<String> generatedComplaintIds = Set<String>();
  static String generateComplaintId() {
    Random random = Random();
    String orderId;
    do {
      int randomNumber = random.nextInt(10000); // Generate a random number between 0 and 9999
      orderId = randomNumber.toString().padLeft(4, '0'); // Ensure the order ID is exactly 4 digits long
    } while (generatedComplaintIds.contains(orderId)); // Repeat if the generated order ID already exists
    generatedComplaintIds.add(orderId); // Add the generated order ID to the set
    return orderId;
  }
}
