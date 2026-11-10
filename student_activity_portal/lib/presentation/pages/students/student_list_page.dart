import 'package:flutter/material.dart';

import '../../../business/providers/student_provider.dart';
import '../../../data/models/student.dart';
import 'add_student_page.dart';
import 'edit_student_page.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  late final StudentProvider _studentProvider;

  @override
  void initState() {
    super.initState();
    _studentProvider = StudentProvider();
    _studentProvider.loadStudents();
  }

  @override
  void dispose() {
    _studentProvider.dispose();
    super.dispose();
  }

  Future<void> _editStudent(StudentModel student) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditStudentPage(
          student: student,
          studentProvider: _studentProvider,
        ),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật sinh viên thành công.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _openAddStudentPage() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddStudentPage(studentProvider: _studentProvider),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      await _studentProvider.loadStudents();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thêm sinh viên thành công!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _deleteStudent(StudentModel student) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text(
          'Bạn có chắc chắn muốn vô hiệu hóa sinh viên '
          '${student.fullName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final success = await _studentProvider.deleteStudent(student.studentId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Đã vô hiệu hóa sinh viên ${student.fullName}.'
              : _studentProvider.errorMessage ?? 'Không thể xóa sinh viên.',
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách sinh viên'),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: _studentProvider,
        builder: (context, child) {
          if (_studentProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_studentProvider.errorMessage != null &&
              _studentProvider.students.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_studentProvider.errorMessage!),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _studentProvider.loadStudents,
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final students = _studentProvider.students;

          if (students.isEmpty) {
            return RefreshIndicator(
              onRefresh: _studentProvider.loadStudents,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 180),
                  Icon(Icons.people_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Center(child: Text('Chưa có dữ liệu sinh viên.')),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _studentProvider.loadStudents,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: students.length,
              itemBuilder: (context, index) {
                return _buildStudentCard(students[index]);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddStudentPage,
        tooltip: 'Thêm sinh viên',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStudentCard(StudentModel student) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            student.fullName.isNotEmpty
                ? student.fullName[0].toUpperCase()
                : '?',
          ),
        ),
        title: Text(
          student.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('MSSV: ${student.studentCode}'),
            Text('Lớp: ${student.className ?? 'Chưa cập nhật'}'),
            Text('Email: ${student.email}'),
          ],
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              tooltip: 'Chỉnh sửa',
              onPressed: () => _editStudent(student),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Xóa',
              onPressed: () => _deleteStudent(student),
            ),
          ],
        ),
      ),
    );
  }
}
