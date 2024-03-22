import 'dart:math';
import 'package:mongo_dart/mongo_dart.dart';

class Complaint {
  ObjectId? id;
  late String name;
  late String email;
  late String contact;
  late String description;
  late String complaintId;
  late String deviceToken;
  bool notified;
  DateTime dateTime;

  Complaint({
    this.id,
    required this.name,
    required this.email,
    required this.contact,
    required this.description,
    required this.complaintId,
    required this.deviceToken,
    required this.dateTime,
    this.notified = false,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      contact: json['contact'],
      description: json['description'],
      complaintId: json['complaintId'],
      dateTime: json['dateTime'],
      deviceToken: json['deviceToken'], // Initialize device token from JSON
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
      'dateTime': dateTime,
      'deviceToken': deviceToken, // Include device token in JSON
    };
  }

  static Set<String> generatedComplaintIds = Set<String>();
  static String generateComplaintId() {
    Random random = Random();
    String orderId;
    do {
      int randomNumber = random.nextInt(10000);
      orderId = randomNumber.toString().padLeft(4, '0');
    } while (generatedComplaintIds.contains(orderId));
    generatedComplaintIds.add(orderId);
    return orderId;
  }
}
