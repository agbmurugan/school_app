import 'package:school_app/models/biodata.dart';

class Admin extends Bio {
  Admin({email, gender, icNumber, name, address, imageUrl, addressLine1, addressLine2, city, lastName, primaryPhone, secondaryPhone, state, docId})
      : super(
          docId: docId,
          email: email,
          entityType: EntityType.admin,
          gender: gender,
          icNumber: icNumber,
          name: name,
          address: address,
          imageUrl: imageUrl,
          addressLine1: addressLine1,
          addressLine2: addressLine2,
          city: city,
          lastName: lastName,
          primaryPhone: primaryPhone,
          secondaryPhone: secondaryPhone,
          state: state,
        );
  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
        docId: json['docId'],
        gender: Gender.values.elementAt(json["gender"]),
        icNumber: json["icNumber"],
        email: json["email"],
        name: json["name"],
        address: json["address"] ?? '',
        imageUrl: json["imageUrl"],
        addressLine1: json['addressLine1'],
        addressLine2: json['addressLine2'],
        city: json['city'],
        lastName: json['lastName'],
        primaryPhone: json['primaryPhone'],
        secondaryPhone: json['secondaryPhone'],
        state: json['state'],
      );

  toJson() {
    var map = toBioJson();
    return map;
  }
}
