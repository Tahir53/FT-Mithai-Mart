class Complaint {
  late String title;
  late String description;

  Complaint({required this.description});

  Map<String, dynamic> toJson() {
    return {
      'description': description,
    };
  }
}