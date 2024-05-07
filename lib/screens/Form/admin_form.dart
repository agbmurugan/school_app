import 'package:flutter/material.dart';
import 'package:school_app/models/admin.dart';
import 'package:school_app/widgets/theme.dart';

import '../../constants/constant.dart';
import '../../constants/get_constants.dart';
import '../../constants/states.dart';
import '../../controllers/admin_controller.dart';
import '../../models/biodata.dart';
import '../../models/response.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_text_field.dart';
import 'controllers/admin_form_controller.dart';
import 'package:get/get.dart';

class AdminForm extends StatefulWidget {
  const AdminForm({
    Key? key,
    this.admin,
  }) : super(key: key);

  final Admin? admin;
  static String routeName = '/admin';

  @override
  State<AdminForm> createState() => _AdminFormState();
}

enum FormMode { add, update, view }

class _AdminFormState extends State<AdminForm> {
  late FormMode formMode;
  late AdminFormController controller;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    formMode = widget.admin == null ? FormMode.add : FormMode.update;
    controller = widget.admin == null ? AdminFormController() : AdminFormController.fromAdmin(widget.admin!);
    super.initState();
  }

  String? requiredValidator(String? val) {
    var text = val ?? '';
    if (text.isEmpty) {
      return "This is a required field";
    }
    return null;
  }

  String? icValidator(String? val) {
    var text = val ?? '';
    if (text.length != 12 && text.isNumericOnly) {
      return "Please enter a valid IC Number";
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
                  'Admin Form',
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
                        hintText: 'Admin Name',
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
                            DropdownMenuItem(child: Text('Male'), value: Gender.male),
                            DropdownMenuItem(child: Text('Female'), value: Gender.female),
                            DropdownMenuItem(child: Text('Unspecified'), value: Gender.unspecified),
                          ],
                          selectedValue: controller.gender),
                    ),
                    SizedBox(
                      width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
                      child: CustomTextField(
                        validator: icValidator,
                        controller: controller.icNumber,
                        labelText: 'IC Number',
                        hintText: 'Enter IC Number',
                        enabled: widget.admin == null,
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
                      validator: (text) {
                        if ((text ?? '').removeAllWhitespace.isEmail) {
                          return null;
                        } else {
                          return 'Please enter a valid email';
                        }
                      },
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
                  SizedBox(
                    width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
                    child: CustomDropDown<String?>(
                      selectedValue: controller.city,
                      items: getCities(controller.state),
                      labelText: "City",
                      onChanged: (city) {
                        controller.city = city;
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
                          var admin = controller.admin;
                          var adminController = AdminController(admin);
                          Future<Result> future;
                          if (formMode == FormMode.add) {
                            future = adminController.add();
                          } else {
                            future = adminController.change();
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

