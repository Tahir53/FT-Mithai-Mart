import 'package:mongo_dart/mongo_dart.dart';

class Complaint {
  ObjectId? id;
  late String name;
  late String email;
  late String contact;
  late String description;

  Complaint(
      {this.id,
      required this.name,
      required this.email,
      required this.contact,
      required this.description});

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      contact: json['contact'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'contact': contact,
      'description': description,
    };
  }
}
