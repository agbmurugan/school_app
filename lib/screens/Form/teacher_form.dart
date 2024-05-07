import 'package:flutter/material.dart';
import 'package:school_app/controllers/Attendance%20API/department_controller.dart';
import 'package:school_app/controllers/teacher_controller.dart';
import 'package:school_app/models/Attendance/department.dart';
import 'package:school_app/models/teacher.dart';
import 'package:school_app/widgets/theme.dart';

import '../../constants/constant.dart';
import '../../constants/get_constants.dart';
import '../../constants/states.dart';
import '../../models/biodata.dart';
import '../../models/response.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_text_field.dart';
import 'controllers/teacher_form_controller.dart';

class TeacherForm extends StatefulWidget {
  const TeacherForm({
    Key? key,
    this.teacher,
  }) : super(key: key);

  final Teacher? teacher;
  static String routeName = '/teacher';

  @override
  State<TeacherForm> createState() => _TeacherFormState();
}

enum FormMode { add, update, view }

class _TeacherFormState extends State<TeacherForm> {
  late FormMode formMode;
  late TeacherFormController controller;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    formMode = widget.teacher == null ? FormMode.add : FormMode.update;
    controller = widget.teacher == null ? TeacherFormController() : TeacherFormController.fromTeacher(widget.teacher!);
    super.initState();
  }

  String? requiredValidator(String? val) {
    var text = val ?? '';
    if (text.isEmpty) {
      return "This is a required field";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: isDesktop(context) && isTablet(context) ? EdgeInsets.only(left: getWidth(context) * 0.25) : const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                ),
                title: Text(
                  'Teacher Form',
                  style: getText(context).headline6!.apply(color: getColor(context).primary),
                ),
              ),
              Padding(
                padding: isMobile(context) ? EdgeInsets.symmetric(horizontal: getWidth(context) * 0.25) : EdgeInsets.all(getWidth(context) * 0.05),
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
                        hintText: 'Teacher Name',
                        validator: requiredValidator,
                        controller: controller.name,
                        labelText: 'Name   ',
                      ),
                    ),
                    SizedBox(
                      width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
                      child: CustomDropDown(
                          onChanged: (Gender? text) {
                            setState(() {
                              controller.gender = text!;
                            });
                          },
                          labelText: 'Gender',
                          items: const [
                            DropdownMenuItem(value: Gender.male, child: Text('Male')),
                            DropdownMenuItem(value: Gender.female, child: Text('Female')),
                            DropdownMenuItem(value: Gender.unspecified, child: Text('Unspecified')),
                          ],
                          selectedValue: controller.gender),
                    ),
                    SizedBox(
                      width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
                      child: CustomTextField(
                        validator: requiredValidator,
                        controller: controller.icNumber,
                        labelText: 'IC Number',
                        hintText: 'Enter IC Number',
                        // enabled: widget.teacher == null,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Contact Details',
                  style: getText(context).headline6!.apply(color: getColor(context).primary),
                ),
              ),
              Center(
                child: CustomLayout(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(
                    width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
                    child: CustomTextField(
                      validator: requiredValidator,
                      controller: controller.email,
                      labelText: "Email",
                    ),
                  ),
                  SizedBox(
                    width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
                    child: CustomTextField(
                      validator: requiredValidator,
                      controller: controller.addressLine1,
                      labelText: "Address Line 1",
                    ),
                  ),
                  SizedBox(
                    width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
                    child: CustomTextField(
                      validator: requiredValidator,
                      controller: controller.addressLine2,
                      labelText: "Address Line 2",
                    ),
                  ),
                  SizedBox(
                    width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
                    child: CustomTextField(
                      validator: requiredValidator,
                      controller: controller.primaryPhone,
                      labelText: "Primary Mobile ",
                    ),
                  ),
                ]),
              ),
              Center(
                child: CustomLayout(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(
                    width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
                    child: CustomTextField(
                      validator: requiredValidator,
                      controller: controller.secondaryPhone,
                      labelText: "Secondary Mobile",
                    ),
                  ),
                  SizedBox(
                    width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
                    child: CustomDropDown<String?>(
                      selectedValue: controller.state,
                      validator: requiredValidator,
                      items: stateItems,
                      labelText: "State",
                      onChanged: (state) {
                        setState(() {
                          controller.state = state;
                          controller.city = null;
                        });
                      },
                    ),
                  ),
                  // SizedBox(
                  //   width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
                  //   child: CustomDropDown<String?>(
                  //     selectedValue: controller.city,
                  //     items: getCities(controller.state),
                  //     labelText: "City",
                  //     onChanged: (city) {
                  //       controller.city = city;
                  //     },
                  //   ),
                  // ),
                ]),
              ),
              const Divider(),
              Center(
                child: CustomLayout(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(
                    width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
                    child: CustomDropDown<String?>(
                      labelText: 'Class',
                      items: controller.classItems,
                      selectedValue: controller.className,
                      onChanged: (dept) {
                        setState(() {
                          controller.className = dept;
                          controller.section = null;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
                    child: CustomDropDown<String?>(
                      labelText: 'Section',
                      items: controller.sectionItems,
                      selectedValue: controller.section,
                      onChanged: (dept) {
                        setState(() {
                          controller.section = dept;
                        });
                      },
                    ),
                  ),
                ]),
              ),
              const Divider(),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          var teacher = controller.teacher;
                          var teacherController = TeacherController(teacher);
                          Future<Result> future;
                          if (formMode == FormMode.add) {
                            future = teacherController.add();
                          } else {
                            future = teacherController.change();
                          }
                          showFutureCustomDialog(
                              context: context,
                              future: future,
                              onTapOk: () {
                                Navigator.of(context).pop();
                                formMode = FormMode.update;
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

