import 'package:flutter/material.dart';

import '../../../business/providers/student_provider.dart';

class AddStudentPage extends StatefulWidget {
  final StudentProvider studentProvider;

  const AddStudentPage({super.key, required this.studentProvider});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _studentCodeController = TextEditingController();
  final _classController = TextEditingController();
  final _majorController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _studentCodeController.dispose();
    _classController.dispose();
    _majorController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập $fieldName';
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await widget.studentProvider.createStudent(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      studentCode: _studentCodeController.text.trim(),
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
            widget.studentProvider.errorMessage ?? 'Không thể thêm sinh viên.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String fieldName,
    TextInputType keyboardType = TextInputType.text,
    bool required = true,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: suffixIcon,
        ),
        validator: required
            ? (value) => _validateRequired(value, fieldName)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm sinh viên')),
      body: ListenableBuilder(
        listenable: widget.studentProvider,
        builder: (context, child) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Thông tin tài khoản',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  label: 'Tên đăng nhập *',
                  controller: _usernameController,
                  fieldName: 'tên đăng nhập',
                ),

                _buildTextField(
                  label: 'Mật khẩu *',
                  controller: _passwordController,
                  fieldName: 'mật khẩu',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 8),
                const Text(
                  'Thông tin sinh viên',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  label: 'Họ và tên *',
                  controller: _fullNameController,
                  fieldName: 'họ và tên',
                ),

                _buildTextField(
                  label: 'Email *',
                  controller: _emailController,
                  fieldName: 'email',
                  keyboardType: TextInputType.emailAddress,
                ),

                _buildTextField(
                  label: 'Số điện thoại',
                  controller: _phoneController,
                  fieldName: 'số điện thoại',
                  required: false,
                  keyboardType: TextInputType.phone,
                ),

                _buildTextField(
                  label: 'Mã sinh viên *',
                  controller: _studentCodeController,
                  fieldName: 'mã sinh viên',
                ),

                _buildTextField(
                  label: 'Lớp',
                  controller: _classController,
                  fieldName: 'lớp',
                  required: false,
                ),

                _buildTextField(
                  label: 'Chuyên ngành',
                  controller: _majorController,
                  fieldName: 'chuyên ngành',
                  required: false,
                ),

                const SizedBox(height: 12),

                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: widget.studentProvider.isCreating
                        ? null
                        : _submitForm,
                    icon: widget.studentProvider.isCreating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(
                      widget.studentProvider.isCreating
                          ? 'Đang lưu...'
                          : 'Thêm sinh viên',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
