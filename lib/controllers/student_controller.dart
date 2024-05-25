import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:school_app/controllers/Attendance%20API/employee_controller.dart';
import 'package:school_app/controllers/crud_controller.dart';
import 'package:school_app/models/parent.dart';
import 'package:school_app/models/student.dart';


import '../constants/constant.dart';
import '../models/response.dart';

class StudentController extends GetxController implements CRUD {
  StudentController(this.student);

  final Student student;
  static RxList<Student> studentList = <Student>[].obs;

  static String? selectedIcNumber;
  bool get selected => selectedIcNumber == student.icNumber;

  Parent? father;
  Parent? mother;
  Parent? guardian;

  static Student? get selectedStudent =>
      selectedIcNumber == null ? null : studentList.firstWhere((element) => element.icNumber == selectedIcNumber);

  static listenStudents() {
    Stream<List<Student>> stream = firestore
        .collection('students')
        .snapshots()
        .map((event) => event.docs.map((e) => Student.fromJson(e.data(), e.id)).toList());
    studentList.bindStream(stream);
    return stream;
  }

  @override
  Future<Result> add({Parent? father, Parent? mother, Parent? guardian}) async {
    if (father == null && mother == null && guardian == null) {
      return Result(code: 'Error', message: 'Either Parent or Guardian is Required');
    }
    if (father != null && father.icNumber.isNotEmpty) {
      if (!father.children.contains(student.icNumber)) {
        father.children.add(student.icNumber);
      }
      student.father = father;
      await firestore.collection('parents').where('icNumber', isEqualTo: father.icNumber).get().then((value) async {
        if (value.docs.isNotEmpty) {
          for (var element in value.docs) {
            element.reference.update(father.toJson());
          }
        } else {
          var docId = firestore.collection('parents').doc().id;
          father.docId = docId;
          student.father!.docId = docId;
          student.father = father;
          await firestore.collection('parents').doc(father.icNumber).set(father.toJson());
        }
      });
    }
    if (mother != null && mother.icNumber.isNotEmpty) {
      if (!mother.children.contains(student.icNumber)) {
        mother.children.add(student.icNumber);
      }
      student.mother = mother;
      await firestore.collection('parents').where('icNumber', isEqualTo: mother.icNumber).get().then((value) async {
        if (value.docs.isNotEmpty) {
          for (var element in value.docs) {
            element.reference.update(mother.toJson());
          }
        } else {
          var docId = firestore.collection('parents').doc().id;
          mother.docId = docId;
          student.mother!.docId = docId;
          student.mother = mother;
          await firestore.collection('parents').doc(mother.icNumber).set(mother.toJson());
        }
      });
    }
    if (guardian != null && guardian.icNumber.isNotEmpty) {
      if (!guardian.children.contains(student.icNumber)) {
        guardian.children.add(student.icNumber);
      }
      student.guardian = guardian;
      await firestore.collection('parents').where('icNumber', isEqualTo: guardian.icNumber).get().then((value) async {
        if (value.docs.isNotEmpty) {
          for (var element in value.docs) {
            element.reference.update(guardian.toJson());
          }
        } else {
          var docId = firestore.collection('parents').doc().id;
          guardian.docId = docId;
          student.guardian!.docId = docId;
          student.guardian = guardian;
          await firestore.collection('parents').doc(guardian.icNumber).set(guardian.toJson());
        }
      });
    }

    student.docId = firestore.collection('students').doc().id;

    // try {
    //   var employee = await EmployeeController.addEmployee(student.employee);
    //   student.empId = employee.id;
    // } catch (e) {
    //   if (kDebugMode) {
    //     print(e.toString());
    //   }
    //   return Result.error("Could not sync attendance. Contact Admin");
    // }

    return await firestore
        .collection('students')
        .doc(student.docId)
        .set(student.toJson())
        .then((value) => Result.success("Student added successfully"))
        .onError((error, stackTrace) => Result.error(error.toString()));
  }

  @override
  Future<Result> change({Parent? father, Parent? mother, Parent? guardian, bool uploadPic = false}) async {
    if (father == null && mother == null && guardian == null) {
      return Result(code: 'Error', message: 'Either Parent or Guardian is Required');
    }
    if (father != null && father.icNumber.isNotEmpty) {
      if (!father.children.contains(student.icNumber)) {
        father.children.add(student.icNumber);
      }

      // if (father.docId == null) {
      //   var docId = firestore.collection('parents').doc().id;
      //   father.docId = docId;
      //   student.father!.docId = docId;
      // } else if (student.father != null && student.father!.docId == null) {
      //   student.father!.docId = father.docId;
      // }

      student.father = father;

      await firestore.collection('parents').doc(father.icNumber).set(father.toJson());
    }
    if (mother != null && mother.icNumber.isNotEmpty) {
      if (!mother.children.contains(student.icNumber)) {
        mother.children.add(student.icNumber);
      }
      // if (mother.docId == null) {
      //   var docId = firestore.collection('parents').doc().id;
      //   mother.docId = docId;
      //   student.mother!.docId = docId;
      // } else if (student.mother != null && student.mother!.docId == null) {
      //   student.mother!.docId = mother.docId;
      // }
      student.mother = mother;
      await firestore.collection('parents').doc(mother.icNumber).set(mother.toJson());
    }
    if (guardian != null && guardian.icNumber.isNotEmpty) {
      if (!guardian.children.contains(student.icNumber)) {
        guardian.children.add(student.icNumber);
      }
      // if (guardian.docId == null) {
      //   var docId = firestore.collection('parents').doc().id;
      //   guardian.docId = docId;
      //   student.guardian!.docId = docId;
      // } else if (student.guardian != null && student.guardian!.docId == null) {
      //   student.guardian!.docId = guardian.docId;
      // }
      student.guardian = guardian;
      await firestore.collection('parents').doc(guardian.icNumber).set(guardian.toJson());
    }

    // try {
    //   var employee = await EmployeeController.updateEmployee(student.employee);
    //   student.empId = employee.id;
    // } catch (e) {
    //   // return Result.error("Could not sync attendance. Contact Admin");
    // }

    // print("DOCUMENT ID : ${student.docId}");
    // print("Student Father docId while Updating ${student.father!.docId}");
    // print("Studernt Father while Updating${student.father!.toJson()}");
    return await firestore
        .collection('students')
        .doc(student.docId)
        .update(student.toJson())
        .then((value) => Result.success("Student Updated successfully"))
        .onError((error, stackTrace) => Result.error(error.toString()));
  }

  @override
  Future<Result> delete() async {
    // print("Deleting");
    await firestore.collection('parents').where('parents', arrayContains: student.icNumber).get().then((value) {
      value.docs.map((e) => Parent.fromJson(e.data())).forEach((element) {
        element.children.remove(student.icNumber);
        firestore.collection('parents').doc(element.docId).update({'children': element.children});
      });
    });
    // return firestore
    //     .collection('students')
    //     .doc(student.docId)
    //     .delete()
    //     .then((value) => Result.success("Student Updated successfully"))
    //     .onError((error, stackTrace) => Result.error(error.toString()));

    await firestore.collection('students').doc(student.docId).update({
      'isActive': false
    });

    // Return success result
    return Result.success("Student updated successfully");
  }

  Stream<Student> get stream => firestore
      .collection('students')
      .doc(student.icNumber)
      .snapshots()
      .map((event) => Student.fromJson(event.data()!, event.id));
}
