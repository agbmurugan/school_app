import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_app/models/student.dart';
import 'package:school_app/screens/Form/student_form.dart';

class ChildList extends StatefulWidget {
  const ChildList({Key? key, required this.students}) : super(key: key);

  final List<Student> students;

  @override
  State<ChildList> createState() => _ChildListState();
}

class _ChildListState extends State<ChildList> {
  // int? selectedIndex;

  // @override
  // void initState() {
  //   if (widget.students.isNotEmpty) {
  //     // selectedIndex = 0;
  //     // selectedStudent = widget.students[selectedIndex!];
  //   }
  //   super.initState();
  // }

  // Student? selectedStudent;

  @override
  Widget build(BuildContext context) {
    return widget.students.isEmpty
        ? const Center(
            child: Text("NO CHILD DATA AVAILABLE"),
          )
        : ListView.builder(
            itemCount: widget.students.length,
            itemBuilder: (context, index) {
              var provider;
              var e = widget.students[index];
              if (e.imageUrl == null) {
                provider = const AssetImage('assets/logo.png');
              } else {
                provider = NetworkImage(e.imageUrl!);
              }
              return ListTile(
                selectedColor: Colors.blueGrey,
                // selectedTileColor: Colors.blueAccent.shade100,
                // selected: index == selectedIndex,
                title: Text(e.name),
                subtitle: Text(e.studentClass + " " + e.section),
                leading: CircleAvatar(
                  backgroundImage: provider,
                ),
                onTap: () {
                  // setState(() {
                  //   // selectedIndex = index;
                  //   // selectedStudent = widget.students[index];
                  // });
                  Get.to(StudentForm(
                    student: e,
                  ));
                },
              );
            },
          );
  }
}
