import 'package:get/get.dart';

String? requiredValidator(String? val) {
  var text = val ?? '';
  if (text.isEmpty) {
    return "This is a required field";
  }
  return null;
}

String? alphabetsOnlyValidator(String? val) {
  var text = val ?? '';
  if (text.isNotEmpty && !text.removeAllWhitespace.isAlphabetOnly) {
    return "Enter only alphabets";
  }
  return null;
}

String? requiredAlphabetsonly(String? val) {
  var text = val ?? '';
  if (text.isEmpty) {
    return "This is a required field";
  }
  if (!text.removeAllWhitespace.isAlphabetOnly) {
    return "Enter only alphabets";
  }
  return null;
}

String? requiredEmail(String? val) {
  var text = val ?? '';
  if (text.isEmpty) {
    return "This is a required field";
  }
  if (text.removeAllWhitespace.isEmail) {
    return "Please enter a valid email";
  }
  return null;
}

String? isPhone(String? val) {
  var text = val ?? '';
  if (text.isEmpty) {
    return null;
  }
  if (text.removeAllWhitespace.isPhoneNumber) {
    return "Please enter a valid phone number ";
  }
  return null;
}

String? isRequiredPhone(String? val) {
  var text = val ?? '';
  if (text.removeAllWhitespace.isPhoneNumber) {
    return "Please enter a valid phone number ";
  }
  return null;
}
