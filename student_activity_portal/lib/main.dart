import 'package:flutter/material.dart';

import 'presentation/pages/students/student_list_page.dart';

void main() {
  runApp(const StudentActivityPortalApp());
}

class StudentActivityPortalApp extends StatelessWidget {
  const StudentActivityPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Activity Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const StudentListPage(),
    );
  }
}
