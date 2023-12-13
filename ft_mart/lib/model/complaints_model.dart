class Complaint {
  late String description;
  final String name;
  final String email;
  final String contact;


  Complaint({required this.name, required this.email, required this.contact, required this.description});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'contact': contact,
      'description': description,
    };
  }
}