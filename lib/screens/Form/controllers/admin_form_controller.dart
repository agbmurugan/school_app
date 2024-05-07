import 'package:school_app/constants/constant.dart';
import 'package:school_app/models/admin.dart';
import 'package:school_app/screens/Form/controllers/bio_form_controller.dart';

class AdminFormController with BioFormController {
  String? className;
  String? section;
  String? docId;

  @override
  clear() {
    className = null;
    section = null;
    docId = null;
    return super.clear();
  }

  AdminFormController();

  factory AdminFormController.fromAdmin(Admin admin) {
    var controller = AdminFormController();
    controller.email.text = admin.email ?? '';
    controller.gender = admin.gender;
    controller.icNumber.text = admin.icNumber;
    controller.name.text = admin.name;
    controller.address.text = admin.address ?? '';
    controller.addressLine1.text = admin.addressLine1 ?? '';
    controller.addressLine2.text = admin.addressLine2 ?? '';
    controller.city = admin.city;
    controller.image = admin.imageUrl ?? '';
    controller.lastName.text = admin.lastName ?? '';
    controller.primaryPhone.text = admin.primaryPhone ?? '';
    controller.secondaryPhone.text = admin.secondaryPhone ?? '';
    controller.state = admin.state;
    controller.docId = admin.docId;
    return controller;
  }

  Admin get admin => Admin(
      email: email.text,
      gender: gender,
      icNumber: icNumber.text,
      name: name.text,
      address: address.text,
      imageUrl: image,
      docId: docId ?? firestore.collection('admins').doc().id,
      addressLine1: addressLine1.text,
      addressLine2: addressLine2.text,
      city: city,
      lastName: lastName.text,
      primaryPhone: primaryPhone.text,
      secondaryPhone: secondaryPhone.text,
      state: state);
}
