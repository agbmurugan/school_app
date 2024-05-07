import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_app/models/response.dart' as r;

import '../constants/constant.dart';

final CollectionReference<Map<String, dynamic>> dashboard = firestore.collection('dashboard');
final DocumentReference<Map<String, dynamic>> classRef = firestore.collection('dashboard').doc('class');

class ClassController extends GetxController {
  @override
  void onInit() {
    listenClass();
    super.onInit();
  }

  static ClassController instance = Get.find();

  Map<String, List<String>> classes = {};

  final name = TextEditingController();
  final section = TextEditingController();

  listenClass() {
    List<String> sections = [];
    dashboard.doc('class').snapshots().listen((event) {
      event.data()?.forEach((key, value) {
        sections = [];
        for (var element in value) {
          sections.add(element.toString());
        }
        classes[key] = sections;
      });
    });
  }

  addClass() {
    classes[name.text.removeAllWhitespace.toUpperCase()] = <String>[];
    return classRef.update(classes).then((value) => r.Result.success("Class Submitted"));
  }

  addSection(String className, String section) {
    classes[className] = classes[className] ?? [];
    classes[className]!.add(section.toUpperCase());
    return classRef.update(classes).then((value) => r.Result.success("Section added"));
  }
}

var classController = ClassController.instance;
