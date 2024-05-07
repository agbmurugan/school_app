// ignore_for_file: avoid_print

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_app/constants/constant.dart';
import 'package:school_app/controllers/attendance_controller.dart';
import 'package:school_app/models/Attendance/department.dart';

class DepartmentController extends GetxController {
  static DepartmentController instance = Get.find();

  List<Department> departments = [];

  List<Department> getClasses() {
    return departments.where((element) => element.parentDept == 2).toList();
  }

  List<DropdownMenuItem<Department>> getClassItems() {
    var items = getClasses().map((e) => DropdownMenuItem(child: Text(e.deptName), value: e)).toList();
    items.add(const DropdownMenuItem(child: Text("None")));
    return items;
  }

  List<DropdownMenuItem<Department>> getSectionsItems(int? id) {
    List<DropdownMenuItem<Department>> items = [];
    if (id != null) {
      items = getSections(id).map((e) => DropdownMenuItem(child: Text(e.deptName), value: e)).toList();
      // print(items.map((e) => e.value?.id));
    }
    items.add(const DropdownMenuItem(child: Text("None")));
    // print(items.length);
    return items;
  }

  List<Department> getSections(int id) {
    return departments.where((element) => element.parentDept == id).toList();
  }

  Future<Department> addDepartment(Department department) {
    var callable = functions.httpsCallable('addDepartment', options: HttpsCallableOptions(timeout: const Duration(seconds: 5)));
    var data = department.toJson();
    data.addAll({'token': AttendanceController.token});
    return callable.call(data).then((value) {
      var dept = Department.fromJson(value.data);
      departments.add(dept);
      return dept;
    });
  }

  Future<void> loadDepartments() async {
    var callable = functions.httpsCallable('loadDepartment', options: HttpsCallableOptions(timeout: const Duration(seconds: 5)));
    return callable.call({'token': AttendanceController.token}).then((value) {
      var data = value.data;
      if (data is List) {
        List<Department> deptList = [];
        for (var element in data) {
          try {
            var department = Department.fromJson(element);
            deptList.add(department);
          } catch (e) {
            // print(element);
            // print(e.toString());
          }
        }
        departments = deptList;
        // print(departments.map((e) => e.toJson()));
      } else {
        departments = departments;
        // print("Could not load departments.. Error occured.");
      }
      return;
    });
  }

  Future<Department> updateDepartment(int id, String deptName, String deptCode) async {
    var callable = functions.httpsCallable('updateDepartment', options: HttpsCallableOptions(timeout: const Duration(seconds: 5)));
    var data = {
      "dept_code": deptCode,
      "dept_name": deptName,
      "id": id,
    };
    data.addAll({'token': AttendanceController.token});
    return callable.call(data).then((value) => Department.fromJson(value.data));
  }

  Department? findDepartment({required String className, String? sectionName}) {
    if (sectionName == null) {
      return departments.firstWhereOrNull((element) => element.deptName == className);
    } else {
      int? parentid = departments.firstWhereOrNull((element) => element.deptName == className)?.id;
      if (parentid != null) {
        return departments.firstWhereOrNull((element) => element.parentDept == parentid && element.deptName == sectionName);
      }
    }
    return null;
  }

  final classNameController = TextEditingController();
  final sectionNameController = TextEditingController();
}

DepartmentController departmentListController = DepartmentController.instance;
