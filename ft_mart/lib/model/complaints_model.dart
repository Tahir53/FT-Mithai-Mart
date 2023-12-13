class Complaint {
  late String title;
  late String description;
  final String name;
  final String email;


  Complaint({required this.description, required this.name, required this.email});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'description': description,
    };
  }
}