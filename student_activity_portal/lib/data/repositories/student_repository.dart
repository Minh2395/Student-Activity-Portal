import 'dart:convert';

import '../datasources/remote/api_client.dart';
import '../datasources/remote/api_config.dart';
import '../models/student.dart';

class StudentRepository {
  final ApiClient _apiClient;

  StudentRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient(baseUrl: ApiConfig.baseUrl);

  // Lấy danh sách sinh viên
  Future<List<StudentModel>> getStudents() async {
    final response = await _apiClient.get('/students');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

      return data
          .map((item) => StudentModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception(
      'Không thể tải danh sách sinh viên. '
      'HTTP ${response.statusCode}: ${response.body}',
    );
  }

  // Lấy thông tin sinh viên theo ID
  Future<StudentModel> getStudentById(int id) async {
    final response = await _apiClient.get('/students/$id');

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      return StudentModel.fromJson(data as Map<String, dynamic>);
    }

    if (response.statusCode == 404) {
      throw Exception('Không tìm thấy sinh viên.');
    }

    throw Exception(
      'Không thể tải thông tin sinh viên. '
      'HTTP ${response.statusCode}',
    );
  }

  Future<StudentModel> createStudent({
    required String username,
    required String password,
    required String fullName,
    required String email,
    String? phoneNumber,
    required String studentCode,
    String? className,
    String? major,
  }) async {
    final response = await _apiClient.post(
      '/students',
      body: {
        'username': username,
        'password': password,
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'studentCode': studentCode,
        'className': className,
        'major': major,
      },
    );

    final data = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 201 || response.statusCode == 200) {
      return StudentModel.fromJson(data as Map<String, dynamic>);
    }

    final message = data is Map<String, dynamic>
        ? data['message'] ?? data['title'] ?? response.body
        : response.body;

    throw Exception('Không thể thêm sinh viên: $message');
  }

  Future<void> deleteStudent(int id) async {
    final response = await _apiClient.delete('/students/$id');

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    }

    final body = utf8.decode(response.bodyBytes);

    String message = body;

    try {
      final data = jsonDecode(body);

      if (data is Map<String, dynamic>) {
        message = data['message'] ?? data['title'] ?? body;
      }
    } catch (_) {
      // Giữ nguyên nội dung phản hồi nếu không phải JSON.
    }

    throw Exception('Không thể xóa sinh viên: $message');
  }

  Future<void> updateStudent({
    required int id,
    required String fullName,
    required String email,
    String? phoneNumber,
    String? className,
    String? major,
  }) async {
    final response = await _apiClient.put(
      '/students/$id',
      body: {
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'className': className,
        'major': major,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    }

    final body = utf8.decode(response.bodyBytes);

    String message = body;

    try {
      final data = jsonDecode(body);

      if (data is Map<String, dynamic>) {
        message = data['message'] ?? data['title'] ?? body;
      }
    } catch (_) {
      // Giữ nguyên nội dung phản hồi nếu không phải JSON.
    }

    throw Exception('Không thể cập nhật sinh viên: $message');
  }

  // Giải phóng HTTP Client khi không sử dụng nữa
  void dispose() {
    _apiClient.dispose();
  }
}
