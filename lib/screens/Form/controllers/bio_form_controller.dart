import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:image_picker_web/image_picker_web.dart';

import '../../../models/biodata.dart';

enum Provide { network, memory, logo }

class BioFormController {
  final name = TextEditingController();
  final lastName = TextEditingController();
  final icNumber = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();
  final addressLine1 = TextEditingController();
  final addressLine2 = TextEditingController();
  final empCode = TextEditingController();
  String? state;
  String? city;
  String? docId;
  final primaryPhone = TextEditingController();
  final secondaryPhone = TextEditingController();
  // final imageUrl = TextEditingController();
  Gender gender = Gender.unspecified;
  String? image;

  Provide show = Provide.logo;
  ImageProvider getAvatar() {
    if (fileData != null) {
      return MemoryImage(fileData!);
    } else if (image != null) {
      return NetworkImage(image!);
    } else {
      return const AssetImage('assets/logo.png');
    }
  }

  Uint8List? fileData;

  Future<void> imagePicker() async {
    var mediaInfo = await ImagePickerWeb.getImageInfo;
    if (mediaInfo!.data != null && mediaInfo.fileName != null) {
      fileData = mediaInfo.data;
      show = Provide.memory;
    }
    return;
  }

  clear() {
    name.clear();
    lastName.clear();
    icNumber.clear();
    email.clear();
    address.clear();
    addressLine1.clear();
    addressLine2.clear();
    city = null;
    state = null;
    docId = null;
    primaryPhone.clear();
    secondaryPhone.clear();
    gender = Gender.unspecified;
    image = null;
    fileData = null;
  }
}
