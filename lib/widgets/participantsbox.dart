import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_app/constants/constant.dart';
import 'package:school_app/models/biodata.dart';
import 'package:school_app/models/parent.dart';
import 'package:school_app/models/student.dart';
import 'package:school_app/models/teacher.dart';

class CCTextBox extends StatefulWidget {
  const CCTextBox({Key? key, required this.bios}) : super(key: key);

  final List<Bio> bios;

  @override
  _CCTextBoxState createState() => _CCTextBoxState();
}

class _CCTextBoxState extends State<CCTextBox> {
  List<Bio> get bios => widget.bios;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  findPeople(String string) async {
    List<Bio> bios = [];
    try {
      var studentList = students.where("search", arrayContains: _emailController.text.toLowerCase()).get().then((value) {
        bios.addAll(value.docs.map((e) => Student.fromJson(e.data(), e.id)));
      });
      var parentsList = firestore.collection('parents').where("search", arrayContains: _emailController.text.toLowerCase()).get().then((value) {
        bios.addAll(value.docs.map((e) => Parent.fromJson(e.data())));
      });
      var teachersList = firestore.collection('teachers').where("search", arrayContains: _emailController.text.toLowerCase()).get().then((value) {
        bios.addAll(value.docs.map((e) => Teacher.fromJson(e.data())));
      });

      await Future.wait([studentList, parentsList, teachersList]);
      return bios;
    } catch (e) {
      if (kDebugMode) {
        // print(e.toString());
      }
      return bios;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          constraints: const BoxConstraints(maxWidth: 200, minWidth: 0, minHeight: 200),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ...bios.map((bio) => Chip(label: Text(bio.name))).toList(),
              ],
            ),
          ),
        ),
        Expanded(
          child: Autocomplete<String>(
            optionsBuilder: (textValue) async {
              return <String>[];
            },
            fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
              return TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
                ),
                controller: _emailController,
                onFieldSubmitted: (String string) {},
              );
            },
          ),
        )
      ],
    );
  }
}
