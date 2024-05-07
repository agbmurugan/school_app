import 'package:get/get_utils/get_utils.dart';
import 'package:flutter/material.dart';
import 'package:school_app/constants/constant.dart';
import 'package:school_app/controllers/classlist_controller.dart';
import 'package:school_app/controllers/student_controller.dart';
import 'package:school_app/screens/Form/controllers/bio_form_controller.dart';

import '../../../models/parent.dart';
import '../../../models/response.dart' as r;
import '../../../models/student.dart';

class StudentFormController with BioFormController {
  Parent? father;
  Parent? mother;
  Parent? guardian;

  final studentClass = TextEditingController();
  final section = TextEditingController();

  String? classField;
  String? sectionField;
  final List<TextEditingController> siblings = [TextEditingController()];

  String? docId;

  StudentFormController();

  List<DropdownMenuItem<String>> get classItems {
    List<DropdownMenuItem<String>> items = classController.classes.keys
        .map((e) => DropdownMenuItem<String>(
              child: Text(e.toUpperCase()),
              value: e,
            ))
        .toList();
    items.add(const DropdownMenuItem(child: Text("None")));
    return items;
  }

  List<DropdownMenuItem<String>> get sectionItems {
    List<DropdownMenuItem<String>> items = [];
    if (classField != null) {
      items = (classController.classes[classField] ?? [])
          .map((e) => DropdownMenuItem<String>(
                child: Text(e),
                value: e,
              ))
          .toList();
    }
    items.add(const DropdownMenuItem(child: Text("None")));
    return items;
  }

  @override
  clear() {
    super.clear();
    siblings.clear();
    studentClass.clear();
    section.clear();
  }

  Future<r.Result> createUser() async {
    var snapshot = await students.doc(icNumber.text.toUpperCase().removeAllWhitespace).get();
    if (snapshot.exists) {
      var data = snapshot.data();
      return r.Result.error("ID is taken by another student ${data!['name']}");
    }
    if (fileData != null) {
      image = await uploadImage(fileData!, icNumber.text.toUpperCase().removeAllWhitespace);
    }

    var controller = StudentController(student);

    return controller.add().then((value) {
      clear();
      return value;
    });
  }

  Future<r.Result> updateUser({bool nameCheck = false}) async {
    if (fileData != null) {
      image = await uploadImage(fileData!, icNumber.text);
    }
    if (nameCheck) {
      var snapshot = await students.doc(icNumber.text.toUpperCase().removeAllWhitespace).get();
      if (snapshot.exists) {
        var data = snapshot.data();
        return r.Result.error("ID is taken by another student ${data!['name']}");
      }
    }
    var controller = StudentController(student);
    return controller.change().then((value) {
      // session.loadStudents();
      return value;
    });
  }

  Student get student => Student(
        docId: docId,
        name: name.text,
        icNumber: icNumber.text.toUpperCase().removeAllWhitespace,
        email: email.text,
        studentClass: classField!,
        imageUrl: image,
        addressLine1: addressLine1.text,
        addressLine2: addressLine2.text,
        city: city,
        primaryPhone: primaryPhone.text,
        secondaryPhone: secondaryPhone.text,
        section: sectionField!,
        address: addressLine1.text,
        gender: gender,
        father: father,
        guardian: guardian,
        mother: mother,
        state: state,
      );

  factory StudentFormController.fromStudent(Student student) {
    StudentFormController controller = StudentFormController();
    controller.docId = student.docId;
    controller.name.text = student.name;
    controller.icNumber.text = student.icNumber;
    controller.image = student.imageUrl;
    controller.state = student.state;
    controller.classField = student.studentClass;
    controller.sectionField = student.section;
    controller.email.text = student.email ?? '';
    controller.addressLine1.text = student.addressLine1 ?? '';
    controller.addressLine2.text = student.addressLine2 ?? '';
    controller.city = student.city;
    controller.mother = student.mother;
    controller.father = student.father;
    controller.guardian = student.guardian;
    controller.gender = student.gender;
    controller.primaryPhone.text = student.primaryPhone ?? '';
    controller.secondaryPhone.text = student.secondaryPhone ?? '';
    controller.siblings.clear();

    return controller;
  }
}
