class CustomizationOption {
  final String name;
  final List<String> imageUrls;

  CustomizationOption({required this.name, required this.imageUrls});

  factory CustomizationOption.fromJson(Map<String, dynamic> json) {
    return CustomizationOption(
      name: json['name'],
      imageUrls: List<String>.from(json['imageUrls']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrls': imageUrls,
    };
  }
}