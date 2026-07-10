class CourtModel {
  final String id;
  final String name;
  final String type;
  final String description;
  final String imageUrl;
  final int price;
  final bool isAvailable;

  CourtModel({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.isAvailable,
  });

  factory CourtModel.fromJson(Map<String, dynamic> json) {
    return CourtModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      price: json['price'],
      isAvailable: json['is_available'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'image_url': imageUrl,
      'price': price,
      'is_available': isAvailable,
    };
  }
}
