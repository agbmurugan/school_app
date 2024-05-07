import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_app/constants/constant.dart';
import 'package:school_app/models/session.dart';

import '../screens/Form/controllers/student_form_controller.dart';

final CollectionReference<Map<String, dynamic>> queue = firestore.collection('NewQueue');

class SessionController extends GetxController {
  static SessionController instance = Get.find();
  SessionController(this.session);
  final MySession session;
  final PageController controller = PageController(initialPage: 0);
  StudentFormController formcontroller = StudentFormController();

  bool showSideBar = true;

  int get pageIndex => session.page;
  set pageIndex(int page) {
    session.page = page;
    update();
  }
}

SessionController session = SessionController.instance;
