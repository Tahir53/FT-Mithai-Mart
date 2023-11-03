import 'package:mongo_dart/mongo_dart.dart';

class CustomerModel {
  ObjectId? id;
  final String? name;
  final String? email;
  final String? address;
  final String? contact;
  final String? password;

  CustomerModel({this.id, this.name, this.email, this.address, this.contact, this.password});

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json["_id"],
      name: json['name'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      contact: json['contact'] as String?,
      password: json['password'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["_id"] = id;
    data['name'] = name;
    data['email'] = email;
    data["password"] = password;
    data['contact'] = contact;
    return data;
  }
}
