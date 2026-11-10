class NotificationModel {
  final int notificationId;
  final String title;
  final String content;
  final DateTime createdAt;

  const NotificationModel({
    required this.notificationId,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notificationId'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
