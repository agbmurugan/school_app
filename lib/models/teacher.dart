import 'package:school_app/controllers/teacher_controller.dart';
import 'package:school_app/models/Attendance/employee.dart';

import 'biodata.dart';

class Teacher extends Bio {
  Teacher(
      {required this.className,
      required this.section,
      required String email,
      required String icNumber,
      required String name,
      required Gender gender,
      String? address,
      String? addressLine1,
      String? addressLine2,
      String? city,
      String? imageUrl,
      String? lastName,
      String? primaryPhone,
      String? secondaryPhone,
      String? state,
      required String? empCode,
      this.uid,
      this.empId,
      String? docId})
      : super(
          docId: docId,
          email: email,
          entityType: EntityType.teacher,
          icNumber: icNumber,
          name: name,
          gender: gender,
          address: address,
          addressLine1: addressLine1,
          addressLine2: addressLine2,
          city: city,
          imageUrl: imageUrl,
          lastName: lastName,
          primaryPhone: primaryPhone,
          secondaryPhone: secondaryPhone,
          state: state,
        );

  String? className;
  String? section;
  String? uid;
  int? empId;

  static Map<Gender, String> genderCode = {Gender.male: 'M', Gender.female: 'F', Gender.unspecified: 'S'};

  Employee get employee => Employee(empCode: docId!, department: 3, gender: genderCode[gender]!, firstName: name);

  TeacherController get controller => TeacherController(this);

  factory Teacher.fromJson(json) => Teacher(
      empCode: json["empCode"],
      gender: Gender.values.elementAt(json["gender"]),
      className: json["className"],
      section: json["section"],
      email: json["email"],
      icNumber: json["icNumber"],
      name: json["name"],
      uid: json["uid"],
      address: json["address"],
      addressLine1: json["addressLine1"],
      addressLine2: json["addressLine2"],
      city: json["city"],
      imageUrl: json["imageUrl"],
      lastName: json["lastName"],
      primaryPhone: json["primaryPhone"],
      secondaryPhone: json["secondaryPhone"],
      state: json["state"],
      docId: json["docId"],
      empId: json["empId"]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "className": className,
      "section": section,
      "uid": uid,
      "docId": docId,
      "empId": empId,
    };
    map.addAll(super.toBioJson());
    return map;
  }
}
