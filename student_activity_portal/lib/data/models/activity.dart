class ActivityModel {
  final int activityId;
  final int categoryId;
  final int organizerId;
  final String activityName;
  final String? description;
  final String? location;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime registrationDeadline;
  final int maxParticipants;
  final String status;
  final DateTime createdAt;

  const ActivityModel({
    required this.activityId,
    required this.categoryId,
    required this.organizerId,
    required this.activityName,
    this.description,
    this.location,
    required this.startTime,
    required this.endTime,
    required this.registrationDeadline,
    required this.maxParticipants,
    required this.status,
    required this.createdAt,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      activityId: json['activityId'] as int,
      categoryId: json['categoryId'] as int,
      organizerId: json['organizerId'] as int,
      activityName: json['activityName'] as String,
      description: json['description'] as String?,
      location: json['location'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      registrationDeadline: DateTime.parse(
        json['registrationDeadline'] as String,
      ),
      maxParticipants: json['maxParticipants'] as int,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activityId': activityId,
      'categoryId': categoryId,
      'organizerId': organizerId,
      'activityName': activityName,
      'description': description,
      'location': location,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'registrationDeadline': registrationDeadline.toIso8601String(),
      'maxParticipants': maxParticipants,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
