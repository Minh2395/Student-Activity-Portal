import 'package:flutter/material.dart';

import '../../../business/providers/student_provider.dart';
import '../../../data/models/student.dart';

class EditStudentPage extends StatefulWidget {
  final StudentModel student;
  final StudentProvider studentProvider;

  const EditStudentPage({
    super.key,
    required this.student,
    required this.studentProvider,
  });

  @override
  State<EditStudentPage> createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _classController;
  late final TextEditingController _majorController;

  @override
  void initState() {
    super.initState();

    final student = widget.student;

    _fullNameController = TextEditingController(text: student.fullName);
    _emailController = TextEditingController(text: student.email);
    _phoneController = TextEditingController(text: student.phoneNumber ?? '');
    _classController = TextEditingController(text: student.className ?? '');
    _majorController = TextEditingController(text: student.major ?? '');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _classController.dispose();
    _majorController.dispose();
    super.dispose();
  }

  Future<void> _updateStudent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await widget.studentProvider.updateStudent(
      id: widget.student.studentId,
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      className: _classController.text.trim().isEmpty
          ? null
          : _classController.text.trim(),
      major: _majorController.text.trim().isEmpty
          ? null
          : _majorController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.studentProvider.errorMessage ??
                'Cập nhật sinh viên thất bại.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool requiredField = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        validator: requiredField
            ? (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập $label';
                }
                return null;
              }
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chỉnh sửa sinh viên')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                label: 'Họ và tên',
                controller: _fullNameController,
                icon: Icons.person,
                requiredField: true,
              ),
              _buildTextField(
                label: 'Email',
                controller: _emailController,
                icon: Icons.email,
                requiredField: true,
                keyboardType: TextInputType.emailAddress,
              ),
              _buildTextField(
                label: 'Số điện thoại',
                controller: _phoneController,
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                label: 'Lớp',
                controller: _classController,
                icon: Icons.class_,
              ),
              _buildTextField(
                label: 'Chuyên ngành',
                controller: _majorController,
                icon: Icons.school,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ListenableBuilder(
                  listenable: widget.studentProvider,
                  builder: (context, child) {
                    final isUpdating = widget.studentProvider.isUpdating;

                    return ElevatedButton.icon(
                      onPressed: isUpdating ? null : _updateStudent,
                      icon: isUpdating
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: Text(
                        isUpdating ? 'Đang cập nhật...' : 'Lưu thay đổi',
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
