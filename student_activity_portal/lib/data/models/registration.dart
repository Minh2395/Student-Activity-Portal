class RegistrationModel {
  final int registrationId;
  final int studentId;
  final int activityId;
  final DateTime registeredAt;
  final String status;

  const RegistrationModel({
    required this.registrationId,
    required this.studentId,
    required this.activityId,
    required this.registeredAt,
    required this.status,
  });

  factory RegistrationModel.fromJson(Map<String, dynamic> json) {
    return RegistrationModel(
      registrationId: json['registrationId'] as int,
      studentId: json['studentId'] as int,
      activityId: json['activityId'] as int,
      registeredAt: DateTime.parse(json['registeredAt'] as String),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'registrationId': registrationId,
      'studentId': studentId,
      'activityId': activityId,
      'registeredAt': registeredAt.toIso8601String(),
      'status': status,
    };
  }
}
