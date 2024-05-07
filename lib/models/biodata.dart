import 'package:flutter/foundation.dart';
import 'package:school_app/models/student.dart';
import 'package:school_app/models/teacher.dart';

import '../constants/constant.dart';
import 'parent.dart';

class Bio {
  Bio(
      {required this.name,
      required this.entityType,
      required this.icNumber,
      required this.email,
      required this.gender,
      this.address,
      this.lastName,
      this.imageUrl,
      this.addressLine1,
      this.addressLine2,
      this.city,
      this.primaryPhone,
      this.secondaryPhone,
      this.state,
      required this.docId, this.nonHyphenIcNumber});

  String? docId;
  String name;
  String? lastName;
  EntityType entityType;
  String icNumber;
  String? nonHyphenIcNumber;
  String? email;
  String? address;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? state;
  String? primaryPhone;
  String? secondaryPhone;
  String? imageUrl;
  Gender gender;

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    return icNumber == (other as Bio).icNumber;
  }

  factory Bio.fromBioJson(json) => Bio(
        docId: json["docId"],
        name: json["name"] ?? '',
        entityType: EntityType.values.elementAt(json["entityType"]),
        icNumber: json["icNumber"] ?? '',
        email: json["email"] ?? '',
        gender: Gender.values.elementAt(json["gender"]),
        address: json["address"],
        addressLine1: json["addressLine1"],
        addressLine2: json["addressLine2"],
        city: json["city"],
        imageUrl: json["imageUrl"],
        lastName: json["lastName"],
        primaryPhone: json["primaryPhone"],
        secondaryPhone: json["secondaryPhone"],
        state: json["state"], nonHyphenIcNumber: json["nonHyphenIcNumber"],
      );

  List<String> get search {
    List<String> results = [];
    name.split(' ').map((e) => makeSearchstring(e)).forEach((element) {
      results.addAll(element);
    });
    results.addAll(makeSearchstring(icNumber));
    if (email != null) {}
    try {
      results.addAll(makeSearchstring(email!.split('@').first));
    } catch (e) {
      if (kDebugMode) {
        // print(e.toString());
      }
    }
    return results;
  }

  Map<String, dynamic> toBioJson() => {
        "docId": docId,
        "name": name,
        "lastName": lastName,
        "entityType": entityType.index,
        "icNumber": icNumber,
        "nonHyphenIcNumber": nonHyphenIcNumber,
        "email": email,
        "address": address,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "city": city,
        "state": state,
        "primaryPhone": primaryPhone,
        "secondaryPhone": secondaryPhone,
        "imageUrl": imageUrl,
        "gender": gender.index,
        "search": search,
      };

  static String getUrl(EntityType type) {
    switch (type) {
      case EntityType.student:
        return 'https://cdn-icons-png.flaticon.com/512/3829/3829933.png';

      case EntityType.teacher:
        return 'https://cdn-icons-png.flaticon.com/512/4696/4696727.png';

      case EntityType.parent:
        return 'https://cdn-icons-png.flaticon.com/512/780/780270.png';

      case EntityType.admin:
        return 'https://cdn-icons-png.flaticon.com/512/2345/2345338.png';
    }
  }

  static Future<List<Bio>> findPeople(String string) async {
    List<Bio> bios = [];
    try {
      var studentList = students.where("search", arrayContains: string.toLowerCase()).get().then((value) {
        bios.addAll(value.docs.map((e) => Student.fromJson(e.data(), e.id)));
      });
      var parentsList = firestore.collection('parents').where("search", arrayContains: string.toLowerCase()).get().then((value) {
        bios.addAll(value.docs.map((e) => Parent.fromJson(e.data())));
      });
      var teachersList = firestore.collection('teachers').where("search", arrayContains: string.toLowerCase()).get().then((value) {
        bios.addAll(value.docs.map((e) => Teacher.fromJson(e.data())));
      });
      await Future.wait([studentList, parentsList, teachersList]);
      return bios;
    } catch (e) {
      return bios;
    }
  }
}

enum EntityType { student, teacher, parent, admin }

enum Gender { male, female, unspecified }
