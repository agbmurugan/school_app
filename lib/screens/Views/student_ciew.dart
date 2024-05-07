import 'package:flutter/material.dart';
import 'package:school_app/models/student.dart';

class StudentView extends StatefulWidget {
  const StudentView({Key? key, required this.student}) : super(key: key);

  final Student? student;

  @override
  State<StudentView> createState() => _StudentViewState();
}

class _StudentViewState extends State<StudentView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
