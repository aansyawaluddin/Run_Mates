class TipsModel {
  final int id;
  final String imageUrl;
  final String title;
  final String description;

  TipsModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  factory TipsModel.fromJson(Map<String, dynamic> json) {
    return TipsModel(
      id: json['id'],
      imageUrl: json['image_url'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}