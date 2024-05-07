import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_app/controllers/parent_controller.dart';
import 'package:school_app/models/parent.dart';
import 'package:school_app/models/student.dart';
import 'package:school_app/screens/Form/Widgets/childrenLIst.dart';
import 'package:school_app/screens/Form/controllers/parent_form_controller.dart';
import 'package:school_app/screens/Form/student_form.dart';
import 'package:school_app/widgets/theme.dart';

import '../../constants/constant.dart';
import '../../constants/get_constants.dart';
import '../../constants/states.dart';
import '../../models/biodata.dart';
import '../../models/response.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_text_field.dart';

class ParentForm extends StatefulWidget {
  const ParentForm({
    Key? key,
    this.parent,
  }) : super(key: key);

  final Parent? parent;
  static String routeName = '/parent';

  @override
  State<ParentForm> createState() => _ParentFormState();
}

enum FormMode { add, update, view }

class _ParentFormState extends State<ParentForm> {
  late FormMode formMode;
  late ParentFormController controller;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    formMode = widget.parent == null ? FormMode.add : FormMode.update;
    controller = widget.parent == null ? ParentFormController() : ParentFormController.fromParent(widget.parent!);
    getChildern();
    super.initState();
  }

  List<Student> children = [];

  Future<void> getChildern() async {
    if (widget.parent != null) {
      var _controller = ParentController(parent: widget.parent!);
      await firestore.collection('students').where('parents', arrayContains: widget.parent!.icNumber).get().then((value) {
        children = value.docs.map((e) => Student.fromJson(e.data(), e.id)).toList();
      });
      // print(children.length);
    }
  }

  Widget getProfileImage() {
    return Padding(
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
    );
  }

  List<Widget> getTopRow() {
    List<Widget> returns = [];
    // returns.addAll(children.map((e) => ChildTile(student: e)).toList());
    return returns;
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
        appBar: AppBar(
          title: Text(
            'Parent Form',
            style: getText(context).headline6!.apply(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                            insetPadding: EdgeInsets.all(isMobile(context) ? 32 : 300),
                            child: FutureBuilder(
                              future: getChildern(),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                return ChildList(students: children);
                              },
                            ));
                      });
                },
                icon: const Icon(Icons.people)),
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
                  getProfileImage(),
                  StatefulBuilder(builder: (context, setState) {
                    return Column(
                      children: [
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
                                  hintText: 'Parent Name',
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
                                  enabled: widget.parent == null,
                                  validator: requiredValidator,
                                  controller: controller.icNumber,
                                  labelText: 'IC Number',
                                  hintText: 'Enter IC Number',
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
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                            ),
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (controller.fileData != null) {
                                    controller.image =
                                        await uploadImage(controller.fileData!, controller.icNumber.text.toUpperCase().removeAllWhitespace);
                                  }
                                  if (_formKey.currentState!.validate()) {
                                    var parent = controller.parent!;
                                    var parentController = ParentController(parent: parent);
                                    Future<Result> future;
                                    if (formMode == FormMode.add) {
                                      future = parentController.add();
                                    } else {
                                      future = parentController.change();
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
                    );
                  }),
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
