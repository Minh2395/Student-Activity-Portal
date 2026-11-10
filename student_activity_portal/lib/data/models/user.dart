class UserModel {
  final int userId;
  final String username;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String role;
  final bool isActive;
  final DateTime createdAt;

  const UserModel({
    required this.userId,
    required this.username,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

  // Chuyen JSON thanh UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      role: json['role'] as String,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Chuyen UserModel thanh JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'role': role,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
