import 'package:flutter/foundation.dart';

import '../../data/models/student.dart';
import '../../data/repositories/student_repository.dart';

class StudentProvider extends ChangeNotifier {
  final StudentRepository _repository;

  StudentProvider({StudentRepository? repository})
    : _repository = repository ?? StudentRepository();

  List<StudentModel> _students = [];
  bool _isLoading = false;
  bool _isCreating = false;
  bool _isUpdating = false;
  String? _errorMessage;

  List<StudentModel> get students => _students;
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  bool get isUpdating => _isUpdating;
  String? get errorMessage => _errorMessage;

  Future<void> loadStudents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _students = await _repository.getStudents();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<StudentModel?> loadStudentById(int id) async {
    _errorMessage = null;

    try {
      return await _repository.getStudentById(id);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> createStudent({
    required String username,
    required String password,
    required String fullName,
    required String email,
    String? phoneNumber,
    required String studentCode,
    String? className,
    String? major,
  }) async {
    _isCreating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final student = await _repository.createStudent(
        username: username,
        password: password,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        studentCode: studentCode,
        className: className,
        major: major,
      );

      _students.add(student);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  Future<bool> deleteStudent(int id) async {
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteStudent(id);

      _students.removeWhere((student) => student.studentId == id);

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateStudent({
    required int id,
    required String fullName,
    required String email,
    String? phoneNumber,
    String? className,
    String? major,
  }) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.updateStudent(
        id: id,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        className: className,
        major: major,
      );

      // Tải lại danh sách sau khi cập nhật thành công.
      final updatedStudents = await _repository.getStudents();

      _students = updatedStudents;

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}
