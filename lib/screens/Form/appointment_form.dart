import 'dart:async';

import 'package:flutter/material.dart';
import 'package:school_app/screens/Form/controllers/appointment_form_controller.dart';
import 'package:school_app/controllers/appointment_controller.dart';
import 'package:school_app/models/appointment.dart';
import 'package:school_app/models/biodata.dart';
import 'package:school_app/models/response.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:time_range/time_range.dart';
import '../../constants/constant.dart';
import '../../constants/get_constants.dart';
import '../../models/parent.dart';
import '../../models/teacher.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key, this.appointment}) : super(key: key);

  final Appointment? appointment;

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  @override
  void initState() {
    super.initState();
    if (widget.appointment != null) {
      controller = AppointmentFormController.fromAppointment(widget.appointment!);
    } else {
      controller = AppointmentFormController();
    }
  }

  late AppointmentFormController controller;

  Future<List<Bio>> findPeople(String string) async {
    List<Bio> bios = [];

    try {
      // var studentList = students.where("search", arrayContains: string.toLowerCase()).get().then((value) {
      //   bios.addAll(value.docs.map((e) => Student.fromJson(e.data())));
      // });
      // var parentsList = firestore.collection('parents').where("search", arrayContains: string.toLowerCase()).get().then((value) {
      //   bios.addAll(value.docs.map((e) => Parent.fromJson(e.data())));
      // });
      var teachersList = firestore.collection('teachers').where("search", arrayContains: string.toLowerCase()).get().then((value) {
        bios.addAll(value.docs.map((e) => Teacher.fromJson(e.data())));
      });
      await Future.wait([teachersList]);
      return bios;
    } catch (e) {
      return bios;
    }
  }

  Future<List<Parent>> findParent(String string) async {
    List<Parent> parents = [];
    try {
      var parentsList = firestore.collection('parents').where("search", arrayContains: string.toLowerCase()).get().then((value) {
        parents.addAll(value.docs.map((e) => Parent.fromJson(e.data())));
      });
      await parentsList;
      return parents;
    } catch (e) {
      return parents;
    }
  }

  final textEditingController = TextEditingController();

  String getUrl(EntityType type) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                'Subject',
                style: getText(context).titleLarge,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  controller: controller.purpose,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Parent',
                style: getText(context).titleLarge,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: LayoutBuilder(builder: (context, constraints) {
                  return Autocomplete<Parent>(
                    initialValue: TextEditingValue(text: controller.parent?.name ?? ''),
                    optionsBuilder: (textEditingValue) async {
                      return findParent(textEditingValue.text);
                    },
                    optionsViewBuilder: (context, onSelected, options) {
                      return SizedBox(
                        height: 200,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: ConstrainedBox(
                                constraints: constraints.copyWith(maxHeight: 600),
                                child: Card(
                                  child: ListView.builder(
                                      itemCount: options.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Card(
                                            child: ListTile(
                                              leading: Image.network(
                                                getUrl(options.elementAt(index).entityType),
                                                height: getHeight(context) * 0.03,
                                              ),
                                              title: Text(options.elementAt(index).name),
                                              subtitle: Text(options.elementAt(index).icNumber),
                                              onTap: () {
                                                onSelected(options.elementAt(index));
                                              },
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    onSelected: (Parent _parent) {
                      controller.parent = _parent;
                    },
                    displayStringForOption: (e) => e.name,
                    fieldViewBuilder: (context, _controller, focusNode, builder) {
                      return TextFormField(
                        focusNode: focusNode,
                        controller: _controller,
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                        validator: (text) {
                          if (controller.parent == null) {
                            return "Select a Parent";
                          }
                          return null;
                        },
                      );
                    },
                  );
                }),
              ),
            ),
            ListTile(
              title: Text(
                'Teachers',
                style: getText(context).titleLarge,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: LayoutBuilder(builder: (context, constraints) {
                  return Autocomplete<Bio>(
                    optionsBuilder: (textEditingValue) async {
                      return findPeople(textEditingValue.text);
                    },
                    optionsViewBuilder: (context, onSelected, options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: ConstrainedBox(
                              constraints: constraints.copyWith(maxHeight: 600),
                              child: Card(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: options.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: ListTile(
                                          leading: Image.network(
                                            getUrl(options.elementAt(index).entityType),
                                            height: getHeight(context) * 0.03,
                                          ),
                                          title: Text(options.elementAt(index).name),
                                          subtitle: Text(options.elementAt(index).icNumber),
                                          onTap: () {
                                            onSelected(options.elementAt(index));
                                          },
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    onSelected: (Bio bio) {
                      setState(() {
                        Bio tempBio = bio;
                        controller.participants.add(tempBio);
                        textEditingController.text = '';
                      });
                    },
                    displayStringForOption: (bio) => bio.name,
                    fieldViewBuilder: (context, controller, focusNode, builder) {
                      return TextFormField(
                        focusNode: focusNode,
                        controller: textEditingController,
                        onChanged: (text) {
                          controller.text = text;
                        },
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                      );
                    },
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ...controller.participants
                        .map((bio) => Chip(
                              avatar: CircleAvatar(
                                child: Image.network(
                                  getUrl(bio.entityType),
                                  height: getHeight(context) * 0.03,
                                ),
                              ),
                              onDeleted: () {
                                setState(() {
                                  controller.participants.removeWhere((element) => element.icNumber == bio.icNumber);
                                });
                              },
                              deleteButtonTooltipMessage: 'Remove',
                              label: Text(bio.name),
                            ))
                        .toList(),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Date',
                style: getText(context).titleLarge,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SfDateRangePicker(
                      initialSelectedDate: controller.date,
                      selectionMode: DateRangePickerSelectionMode.single,
                      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                        controller.date = args.value;
                        controller.parentApproval = false;
                      },
                    ),
                  ),
                ),
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(
                'Time',
                style: getText(context).titleLarge,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TimeRange(
                  fromTitle: Text('FROM', style: getText(context).button),
                  toTitle: Text(
                    'TO',
                    style: getText(context).button,
                  ),
                  titlePadding: 8.0,
                  textStyle: getText(context).bodySmall,
                  activeTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                  borderColor: getColor(context).inversePrimary,
                  activeBorderColor: getColor(context).onTertiaryContainer,
                  backgroundColor: Colors.transparent,
                  activeBackgroundColor: getColor(context).primary,
                  firstTime: const TimeOfDay(hour: 8, minute: 00),
                  lastTime: const TimeOfDay(hour: 20, minute: 00),
                  initialRange: controller.timeRange,
                  timeStep: 10,
                  timeBlock: 30,
                  onFirstTimeSelected: ((hour) {
                    setState(() {
                      controller.fromTime = hour;
                    });
                  }),
                  onRangeCompleted: (range) => setState(() {
                    if (range != null) {
                      controller.toTime = range.end;
                      controller.parentApproval = false;
                    }
                  }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ElevatedButton(
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    child: Text('Submit'),
                  ),
                  onPressed: () {
                    var appointmentController = AppointmentController(controller.appointment);
                    if (controller.appointment.date.isAfter(DateTime.now())) {
                      Future<Result> future;
                      if (widget.appointment != null) {
                        future = appointmentController.change();
                      } else {
                        future = appointmentController.add();
                      }
                      showFutureCustomDialog(
                          context: context,
                          future: future,
                          onTapOk: () {
                            Navigator.of(context).pop();
                          });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a future Date and Time")));
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
