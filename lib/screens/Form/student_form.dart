import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_app/constants/constant.dart';
import 'package:school_app/controllers/attendance_controller.dart';
import 'package:school_app/controllers/student_controller.dart';
import 'package:school_app/models/biodata.dart';
import 'package:school_app/models/parent.dart';
import 'package:school_app/models/response.dart';
import 'package:school_app/models/student.dart';
import 'package:school_app/screens/Form/Widgets/parent_form_widget.dart';
import 'package:school_app/screens/Form/controllers/parent_form_controller.dart';
import 'package:school_app/widgets/custom_drop_down.dart';

import '../../constants/get_constants.dart';
import '../../constants/validators.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/theme.dart';
import 'controllers/student_form_controller.dart';

class StudentForm extends StatefulWidget {
  const StudentForm({
    Key? key,
    this.student,
  }) : super(key: key);

  final Student? student;
  static String routeName = '/student';

  @override
  State<StudentForm> createState() => _StudentFormState();
}

enum FormMode { add, update, view }

class _StudentFormState extends State<StudentForm> {
  late FormMode formMode;
  late StudentFormController controller;
  ParentFormController fatherFormController = ParentFormController();
  ParentFormController motherFormController = ParentFormController();
  ParentFormController guardianFormController = ParentFormController();

  bool duplicateIcNumber = false;

  validateIcNumber() async {
    duplicateIcNumber = false;
    var tempStudents = await students.where('icNumber', isEqualTo: controller.icNumber.text).get();
    if (formMode == FormMode.update) {
      if (tempStudents.docs.length > 1) {
        duplicateIcNumber = true;
      }
    } else {
      if (tempStudents.docs.isNotEmpty) {
        duplicateIcNumber = true;
      }
    }

    // return students.where('ic', isEqualTo: controller.icNumber.text).get().then((value) {
    //   if (value.docs.length > 2) {
    //     duplicateIcNumber = true;
    //   } else if (value.docs.length == 1) {
    //     if (value.docs.first.id != widget.student?.icNumber) {
    //       duplicateIcNumber = true;
    //     } else {
    //       duplicateIcNumber = false;
    //     }
    //   } else {
    //     duplicateIcNumber = false;
    //   }
    // });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    formMode = widget.student == null ? FormMode.add : FormMode.update;
    fatherFormController.gender = Gender.male;
    motherFormController.gender = Gender.female;
    guardianFormController.gender = Gender.unspecified;
    controller = widget.student == null ? StudentFormController() : StudentFormController.fromStudent(widget.student!);
    duplicateIcNumber = false;

    if (widget.student != null) {
      if (widget.student?.father != null) {
        fatherFormController = ParentFormController.fromParent(widget.student!.father!);
      }
      if (widget.student?.mother != null) {
        motherFormController = ParentFormController.fromParent(widget.student!.mother!);
      }
      if (widget.student?.guardian != null) {
        guardianFormController = ParentFormController.fromParent(widget.student!.guardian!);
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Student Form'),
          actions: [
            if (widget.student != null)
              IconButton(
                onPressed: () async {
                  var callable = functions.httpsCallable('getTransaction', options: HttpsCallableOptions(timeout: const Duration(seconds: 5)));

                  var data = {
                    'emp_code': 1,
                    'start_time': DateTime(2022, DateTime.august, 01).toString().substring(0, 19),
                    'end_time': DateTime.now().toString().substring(0, 19),
                    'token': AttendanceController.token
                  };
                  try {
                    var response = await callable.call(data);
                    // print(response.data);
                  } catch (e) {
                    // print(e.toString());
                  }
                },
                icon: const Icon(Icons.calendar_month),
              ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: isDesktop(context) && isTablet(context) ? EdgeInsets.only(left: getWidth(context) * 0.25) : const EdgeInsets.all(8),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        isMobile(context) ? EdgeInsets.symmetric(horizontal: getWidth(context) * 0.25) : EdgeInsets.all(getWidth(context) * 0.05),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 80,
                            foregroundImage: controller.getAvatar(),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              controller.imagePicker().then((value) {
                                setState(() {});
                              });
                            },
                            child: const Text(
                              "Upload Picture",
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Personal Details',
                      style: getText(context).headline6!.apply(color: getColor(context).primary),
                    ),
                  ),
                  Center(
                    child: CustomLayout(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
                          child: CustomTextField(
                            hintText: 'Student Name',
                            validator: requiredAlphabetsonly,
                            controller: controller.name,
                            labelText: 'Name   ',
                          ),
                        ),
                        SizedBox(
                          width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
                          child: CustomDropDown<Gender>(
                              onChanged: (Gender? text) {
                                setState(() {
                                  controller.gender = text!;
                                });
                              },
                              labelText: 'Gender',
                              items: const [
                                DropdownMenuItem(child: Text('Male'), value: Gender.male),
                                DropdownMenuItem(child: Text('Female'), value: Gender.female),
                                DropdownMenuItem(child: Text('Unspecified'), value: Gender.unspecified),
                              ],
                              selectedValue: controller.gender),
                        ),
                        SizedBox(
                          width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
                          child: CustomDropDown<String?>(
                            labelText: 'Class',
                            items: controller.classItems,
                            validator: (val) {
                              if (val == null) {
                                return 'Please select a class';
                              }
                              return null;
                            },
                            selectedValue: controller.classField,
                            onChanged: (text) {
                              setState(() {
                                controller.classField = text;
                                controller.sectionField = null;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
                          child: CustomDropDown<String?>(
                            labelText: 'Section',
                            items: controller.sectionItems,
                            validator: (val) {
                              if (val == null) {
                                return 'Please select a Section';
                              }
                              return null;
                            },
                            selectedValue: controller.sectionField,
                            onChanged: (text) {
                              setState(() {
                                controller.sectionField = text;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: CustomLayout(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
                          child: CustomTextField(
                            // enabled: widget.student == null,
                            validator: (val) {
                              if ((val ?? '').isEmpty) {
                                return 'This is a required field';
                              }
                              if (duplicateIcNumber) {
                                return 'IC Number already taken';
                              }
                              return null;
                            },
                            controller: controller.icNumber,
                            labelText: 'IC Number',
                            hintText: 'Enter IC Number',
                          ),
                        ),
                      ],
                    ),
                  ),
                  ParentForm(controller: fatherFormController, label: 'Father'),
                  ParentForm(
                    controller: motherFormController,
                    label: 'Mother',
                    onChanged: (val) {
                      if (val == true) {
                        setState(() {
                          motherFormController.addressLine1.text = fatherFormController.addressLine1.text;
                          motherFormController.addressLine2.text = fatherFormController.addressLine2.text;
                          motherFormController.state = fatherFormController.state;
                          motherFormController.city = fatherFormController.city;
                        });
                      }
                    },
                  ),
                  ParentForm(controller: guardianFormController, label: 'Guardian'),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                      ),
                      child: ElevatedButton(
                          onPressed: () async {
                            await validateIcNumber();

                            if (_formKey.currentState!.validate()) {
                              Student? student;
                              Parent? father;
                              Parent? mother;
                              Parent? guardian;
                              Future<Result> future;
                              try {
                                student = controller.student;
                                father = fatherFormController.parent;
                                mother = motherFormController.parent;
                                guardian = guardianFormController.parent;

                                if (formMode == FormMode.add) {
                                  if (controller.fileData != null) {
                                    future =
                                        uploadImage(controller.fileData!, controller.icNumber.text.toUpperCase().removeAllWhitespace).then((value) {
                                      student!.imageUrl = value;
                                      var studentController = StudentController(student);
                                      return studentController.add(father: father, mother: mother, guardian: guardian);
                                    }).onError((error, stackTrace) => Result.error(error.toString()));
                                  } else {
                                    var studentController = StudentController(student);
                                    future = studentController.add(father: father, mother: mother, guardian: guardian);
                                  }
                                } else {
                                  if (controller.fileData != null) {
                                    future =
                                        uploadImage(controller.fileData!, controller.icNumber.text.toUpperCase().removeAllWhitespace).then((value) {
                                      student!.imageUrl = value;
                                      var studentController = StudentController(student);
                                      return studentController.change(father: father, mother: mother, guardian: guardian);
                                    }).onError((error, stackTrace) => Result.error(error.toString()));
                                  } else {
                                    var studentController = StudentController(student);
                                    future = studentController.change(father: father, mother: mother, guardian: guardian);
                                  }
                                }
                              } catch (e) {
                                // print(e.toString());
                                future = Result.error("Unknown error") as Future<Result>;
                              }

                              showFutureCustomDialog(
                                  context: context,
                                  future: future,
                                  onTapOk: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    if (formMode == FormMode.add) {
                                      formMode = FormMode.update;
                                    }
                                  });
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 50),
                            child: Text("Submit"),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  // List<Widget> getSiblingsField(BuildContext context) {
  //   List<Widget> list = controller.siblings
  //       .map(
  //         (e) => SizedBox(
  //           width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
  //           child: CustomTextField(
  //             controller: e,
  //             labelText: 'IC Number',
  //           ),
  //         ),
  //       )
  //       .toList();
  //   list.add(SizedBox(
  //     child: Padding(
  //       padding: const EdgeInsets.only(top: 16),
  //       child: TextButton(
  //           onPressed: () {
  //             setState(() {
  //               controller.siblings.add(TextEditingController());
  //             });
  //           },
  //           child: const Text("Add")),
  //     ),
  //   ));
  //   return list;
  // }
}

class CustomTextForm extends StatelessWidget {
  const CustomTextForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getHeight(context) * 0.10,
      width: getWidth(context) * 0.10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text('Name'),
          ),
          TextField(
            decoration: InputDecoration(
              alignLabelWithHint: true,
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: getColor(context).primary)),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: "Ex.Andrew Simons",
            ),
          ),
        ],
      ),
    );
  }
}

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(),
  //     body: Wrap(
  //       children: [
  //         CustomTextFormField(controller: state.name, label: 'Name'),
  //         CustomTextFormField(controller: state.name, label: 'Email'),
  //         CustomTextFormField(controller: state.name, label: 'IC Nmber'),
  //         CustomTextFormField(controller: state.name, label: 'Image Url'),
  //         CustomTextFormField(controller: state.name, label: 'Address'),
  //         CustomDropDown(
  //             labelText: 'Gender',
  //             items: const [
  //               DropdownMenuItem(child: Text('Male'), value: Gender.male),
  //               DropdownMenuItem(child: Text('Female'), value: Gender.female),
  //               DropdownMenuItem(child: Text('Unspecified'), value: Gender.unspecified),
  //             ],
  //             selectedValue: state.gender),
  //       ],
  //     ),
  //   );
  // }

