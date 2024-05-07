import 'package:flutter/material.dart';
import 'package:school_app/controllers/classlist_controller.dart';
import 'package:school_app/models/teacher.dart';
import 'package:school_app/screens/Form/controllers/bio_form_controller.dart';

class TeacherFormController with BioFormController {
  String? className;
  String? section;
  String? uid;
  String? docId;

  @override
  clear() {
    className = null;
    section = null;
    uid = null;
    return super.clear();
  }

  TeacherFormController();

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
    if (className != null) {
      items = (classController.classes[className] ?? [])
          .map((e) => DropdownMenuItem<String>(
                child: Text(e),
                value: e,
              ))
          .toList();
    }
    items.add(const DropdownMenuItem(child: Text("None")));
    return items;
  }

  factory TeacherFormController.fromTeacher(Teacher teacher) {
    var controller = TeacherFormController();
    controller.className = teacher.className;
    controller.section = teacher.section;
    controller.uid = teacher.uid;
    controller.email.text = teacher.email ?? '';
    controller.gender = teacher.gender;
    controller.icNumber.text = teacher.icNumber;
    controller.name.text = teacher.name;
    controller.address.text = teacher.address ?? '';
    controller.addressLine1.text = teacher.addressLine1 ?? '';
    controller.addressLine2.text = teacher.addressLine2 ?? '';
    controller.city = teacher.city;
    controller.image = teacher.imageUrl ?? '';
    controller.lastName.text = teacher.lastName ?? '';
    controller.primaryPhone.text = teacher.primaryPhone ?? '';
    controller.secondaryPhone.text = teacher.secondaryPhone ?? '';
    controller.state = teacher.state;
    controller.docId = teacher.docId!;
    return controller;
  }

  Teacher get teacher => Teacher(
        empCode: empCode.text,
        className: className,
        section: section,
        uid: uid,
        email: email.text,
        gender: gender,
        icNumber: icNumber.text,
        name: name.text,
        address: address.text,
        addressLine1: addressLine1.text,
        addressLine2: addressLine2.text,
        city: city,
        imageUrl: image,
        lastName: lastName.text,
        primaryPhone: primaryPhone.text,
        secondaryPhone: secondaryPhone.text,
        state: state,
        docId: docId,
      );
}
