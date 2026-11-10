class NotificationRecipientModel {
  final int notificationRecipientId;
  final int notificationId;
  final int userId;
  final bool isRead;
  final DateTime? readAt;

  const NotificationRecipientModel({
    required this.notificationRecipientId,
    required this.notificationId,
    required this.userId,
    required this.isRead,
    this.readAt,
  });

  factory NotificationRecipientModel.fromJson(Map<String, dynamic> json) {
    return NotificationRecipientModel(
      notificationRecipientId: json['notificationRecipientId'] as int,
      notificationId: json['notificationId'] as int,
      userId: json['userId'] as int,
      isRead: json['isRead'] as bool,
      readAt: json['readAt'] != null
          ? DateTime.parse(json['readAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationRecipientId': notificationRecipientId,
      'notificationId': notificationId,
      'userId': userId,
      'isRead': isRead,
      'readAt': readAt?.toIso8601String(),
    };
  }
}
