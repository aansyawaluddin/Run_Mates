class NotificationModel {
  final int id;
  final String title;
  final String description;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Tanpa Judul',
      description: json['description'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at']).toLocal(),
    );
  }
}