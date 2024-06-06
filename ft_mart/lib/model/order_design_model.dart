class OrderDesignModel {
  final String? productName;
  final String? boxDesignID;
  final String? ribbonDesignID;
  final String? wrappingDesignID;

  OrderDesignModel({
    this.productName,
    this.boxDesignID,
    this.ribbonDesignID,
    this.wrappingDesignID,
  });

  // Method to convert a JSON map to an instance of OrderDesignModel
  factory OrderDesignModel.fromJson(Map<String, dynamic> json) {
    return OrderDesignModel(
      productName: json['productName'],
      boxDesignID: json['boxDesignID'] ?? 'na',
      ribbonDesignID: json['ribbonDesignID'] ?? 'na',
      wrappingDesignID: json['wrappingDesignID'] ?? 'na',
    );
  }

  // Method to convert an instance of OrderDesignModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'boxDesignID': boxDesignID,
      'ribbonDesignID': ribbonDesignID,
      'wrappingDesignID': wrappingDesignID,
    };
  }
}
