import 'package:school_app/controllers/student_controller.dart';
import 'package:school_app/models/Attendance/employee.dart';
import 'package:school_app/models/biodata.dart';
import 'parent.dart';

class Student extends Bio {
  Student(
      {required String icNumber,
      required this.studentClass,
      required this.section,
      required String name,
      required String email,
      required Gender gender,
      this.father,
      this.guardian,
      this.mother,
      this.empId,
      String? address,
      String? nonHyphenIcNumber,
      String? addressLine1,
      String? addressLine2,
      String? city,
      String? imageUrl,
      String? lastName,
      String? primaryPhone,
      String? secondaryPhone,
      String? state,
      String? docId})
      : super(
          docId: docId,
          name: name,
          email: email,
          entityType: EntityType.student,
          icNumber: icNumber,
          nonHyphenIcNumber: icNumber.replaceAll(" ", "").replaceAll("-", ""),
          address: address,
          gender: gender,
          addressLine1: addressLine1,
          addressLine2: addressLine2,
          city: city,
          imageUrl: imageUrl,
          lastName: lastName,
          primaryPhone: primaryPhone,
          secondaryPhone: secondaryPhone,
          state: state,
        );

  String studentClass;
  String section;
  int? empId;
  Parent? father;
  Parent? mother;
  Parent? guardian;

  static Map<Gender, String> genderCode = {Gender.male: 'M', Gender.female: 'F', Gender.unspecified: 'S'};

  Employee get employee => Employee(empCode: docId ?? '', department: 2, gender: genderCode[gender]!, firstName: name);

  List<String> get parents {
    List<String> result = [];
    if (father != null) {
      result.add(father!.icNumber);
    }
    if (mother != null) {
      result.add(mother!.icNumber);
    }
    if (guardian != null) {
      result.add(guardian!.icNumber);
    }
    return result;
  }

  Bio get bio => this;
  StudentController get controller => StudentController(this);
  factory Student.fromJson(Map<String, dynamic> json, String docId) {
    // print(docId);

    return Student(
        docId: json["docId"],
        icNumber: json["icNumber"],
        nonHyphenIcNumber: json["nonHyphenIcNumber"],
        name: json["name"],
        email: json["email"] ?? '',
        gender: json["gender"] == null ? Gender.male : Gender.values.elementAt(json["gender"]),
        address: json["address"],
        addressLine1: json["addressLine1"],
        addressLine2: json["addressLine2"],
        city: json["city"],
        imageUrl: json["imageUrl"],
        lastName: json["lastName"],
        primaryPhone: json["primaryPhone"],
        secondaryPhone: json["secondaryPhone"],
        state: json["state"],
        //-------------------------------------------
        father: json["father"] != null ? Parent.fromJson(json['father']) : null,
        guardian: json["guardian"] != null ? Parent.fromJson(json['guardian']) : null,
        mother: json["mother"] != null ? Parent.fromJson(json['mother']) : null,
        //-------------------------------------------
        studentClass: json["class"],
        section: json["section"],
        empId: json["empId"]);
  }

  Map<String, dynamic> toJson() => {
        "empId": empId,
        "docId": docId,
        "icNumber": icNumber,
        "nonHyphenIcNumber": icNumber.replaceAll(" ", "").replaceAll("-", ""),
        "name": name,
        "email": email,
        "gender": gender.index,
        "entityType": entityType.index,
        "address": address,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "city": city,
        "imageUrl": imageUrl,
        "lastName": lastName,
        "primaryPhone": primaryPhone,
        'secondaryPhone': secondaryPhone,
        "state": state,
        "search": search,
        //------------
        "father": father?.toJson(),
        "mother": mother?.toJson(),
        "guardian": guardian?.toJson(),
        //------------
        "class": studentClass,
        "section": section,
        //------------
        "parents": parents,
      };
}
