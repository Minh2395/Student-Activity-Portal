class StudentModel {
  final int studentId;
  final int userId;
  final String username;
  final String studentCode;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? className;
  final String? major;
  final bool isActive;
  final DateTime? createdAt;

  const StudentModel({
    required this.studentId,
    required this.userId,
    required this.username,
    required this.studentCode,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.className,
    this.major,
    required this.isActive,
    this.createdAt,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      studentId: json['studentId'] as int,
      userId: json['userId'] as int,
      username: json['username'] as String? ?? '',
      studentCode: json['studentCode'] as String,
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String?,
      className: json['className'] as String?,
      major: json['major'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'userId': userId,
      'username': username,
      'studentCode': studentCode,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'className': className,
      'major': major,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
