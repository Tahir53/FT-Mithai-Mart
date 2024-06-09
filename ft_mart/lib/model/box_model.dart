class CustomizationOption {
  final String name;
  final String value;
  final List<String> imageUrls;

  CustomizationOption(
      {required this.name, required this.imageUrls, required this.value});

  factory CustomizationOption.fromJson(Map<String, dynamic> json) {
    return CustomizationOption(
      name: json['name'],
      value: json['value'] ?? "",
      imageUrls: List<String>.from(json['imageUrls']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'imageUrls': imageUrls,
    };
  }
}
