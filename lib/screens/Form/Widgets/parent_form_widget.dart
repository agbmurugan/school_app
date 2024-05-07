import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:school_app/constants/get_constants.dart';
import 'package:school_app/screens/Form/controllers/parent_form_controller.dart';
import 'package:school_app/widgets/custom_text_field.dart';
import 'package:school_app/widgets/theme.dart';

import '../../../constants/constant.dart';
import '../../../constants/states.dart';
import '../../../constants/validators.dart';
import '../../../models/biodata.dart';
import '../../../models/parent.dart';
import '../../../widgets/custom_drop_down.dart';

class ParentForm extends StatefulWidget {
  const ParentForm({
    Key? key,
    required this.controller,
    required this.label,
    this.onChanged,
  }) : super(key: key);

  final ParentFormController controller;
  final String label;
  final void Function(bool?)? onChanged;

  @override
  State<ParentForm> createState() => _ParentFormState();
}

bool check = false;

class _ParentFormState extends State<ParentForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${widget.label} Details',
            style: getText(context).headline6!.apply(color: getColor(context).primary),
          ),
        ),
        widget.onChanged == null
            ? Container()
            : CheckboxListTile(
                title: const Text('Address same as Father'),
                value: check,
                onChanged: (val) {
                  setState(() {
                    check = val ?? check;
                  });
                  widget.onChanged!(check);
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
        Center(
          child: CustomLayout(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
              width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
              child: LayoutBuilder(builder: (context, constraints) {
                return CustomAutoComplete<Parent>(
                  displayStringForOption: (p0) => p0.icNumber,
                  enabled: true,
                  text: widget.controller.icNumber.text,
                  title: "IC Number",
                  onChanged: (text) {
                    widget.controller.icNumber.text = text;
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        child: ConstrainedBox(
                          constraints: constraints.copyWith(maxHeight: 200),
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 8, right: 16),
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              Parent option = options.elementAt(index);
                              return Card(
                                child: ListTile(
                                  onTap: () {
                                    onSelected(option);
                                  },
                                  title: Text(option.name),
                                  subtitle: Text(option.icNumber),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  optionsBuilder: (p0) {
                    if (widget.controller.gender == Gender.unspecified) {
                      return firestore.collection('parents').get().then((value) {
                        return value.docs.map((e) => Parent.fromJson(e.data())).toList();
                      });
                    } else {
                      return firestore
                          .collection('parents')
                          .where('gender', isEqualTo: widget.controller.gender.index)
                          .where('search', arrayContains: p0.text.toLowerCase())
                          .get()
                          .then((value) {
                        return value.docs.map((e) => Parent.fromJson(e.data())).toList();
                      });
                    }
                  },
                  onSelected: (parent) {
                    setState(() {
                      widget.controller.copyWith(parent);
                    });
                  },
                );
              }),
            ),
            SizedBox(
              width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
              child: CustomTextField(
                validator: alphabetsOnlyValidator,
                controller: widget.controller.name,
                labelText: "Name",
              ),
            ),
            SizedBox(
              width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
              child: CustomTextField(
                validator: (text) {
                  if ((text ?? '').isNotEmpty) {
                    if (!text!.isEmail) {
                      return 'Please enter a valid email';
                    }
                  }
                  return null;
                },
                controller: widget.controller.email,
                labelText: "Email",
              ),
            ),
            SizedBox(
              width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
              child: CustomTextField(
                validator: (text) {
                  if ((text ?? '').isNotEmpty) {
                    if (!text!.isPhoneNumber) {
                      return 'Please enter a valid Phone Number';
                    }
                  }
                  return null;
                },
                controller: widget.controller.primaryPhone,
                labelText: "Mobile Number",
              ),
            ),
            // SizedBox(
            //   width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
            //   child: CustomTextField(
            //     validator: (text) {
            //       if ((text ?? '').isNotEmpty) {
            //         if (!text!.isPhoneNumber) {
            //           return 'Please enter a valid Phone Number';
            //         }
            //       }
            //       return null;
            //     },
            //     controller: widget.controller.secondaryPhone,
            //     labelText: "Secondary Mobile",
            //   ),
            // ),
          ]),
        ),
        Center(
          child: CustomLayout(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
              width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
              child: CustomTextField(
                // validator: requiredValidator,
                controller: widget.controller.addressLine1,
                labelText: "Address Line 1",
              ),
            ),
            SizedBox(
              width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
              child: CustomTextField(
                // validator: requiredValidator,
                controller: widget.controller.addressLine2,
                labelText: "Address Line 2",
              ),
            ),
            SizedBox(
              width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
              child: CustomDropDown<String?>(
                selectedValue: widget.controller.state,
                // validator: requiredValidator,
                items: stateItems,
                labelText: "State",
                onChanged: (state) {
                  setState(() {
                    widget.controller.city = null;
                    widget.controller.state = state;
                  });
                },
              ),
            ),
            // SizedBox(
            //   width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
            //   child: CustomDropDown<String?>(
            //     selectedValue: widget.controller.city,
            //     items: getCities(widget.controller.state),
            //     labelText: "City",
            //     onChanged: (city) {
            //       setState(() {
            //         widget.controller.city = city;
            //       });
            //     },
            //   ),
            // ),
          ]),
        ),
      ],
    );
  }
}
