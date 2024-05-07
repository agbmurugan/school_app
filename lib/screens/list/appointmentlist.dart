import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_app/constants/constant.dart';
import 'package:school_app/controllers/auth_controller.dart';
import 'package:school_app/screens/Form/appointment_form.dart';
import 'package:school_app/screens/list/source/appointmentsource.dart';
import 'package:school_app/models/appointment.dart';

import '../../constants/get_constants.dart';
import '../../controllers/session_controller.dart';
import '../Form/controllers/student_form_controller.dart';

class AppoinmentList extends StatefulWidget {
  const AppoinmentList({Key? key}) : super(key: key);
  static const routeName = '/passArguments';
  @override
  State<AppoinmentList> createState() => _AppoinmentListState();
}

class _AppoinmentListState extends State<AppoinmentList> {
  StudentFormController get controller => session.formcontroller;

  @override
  void initState() {
    fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    toDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 1).subtract(const Duration(days: 1));
    fromDateControler.text = fromDate.toString().substring(0, 10);
    toDateControler.text = toDate.toString().substring(0, 10);
    super.initState();
  }

  AppointmentStatus? status;
  late DateTime fromDate;
  late DateTime toDate;

  final TextEditingController fromDateControler = TextEditingController();
  final TextEditingController toDateControler = TextEditingController();

  List<DropdownMenuItem<AppointmentStatus>> getAppointmentMenuItems() {
    List<DropdownMenuItem<AppointmentStatus>> items = [];
    items.add(const DropdownMenuItem(child: Text("ALL")));
    items.addAll(AppointmentStatus.values.map((e) => DropdownMenuItem(child: Text(e.toString().split('.').last.toUpperCase()), value: e)));
    return items;
  }

  List<Appointment> source = [
    // Appointment(date: DateTime.now(), status: A, approvedBy: 'Admin', location: 'Thoothukudi', raisedBy: 'Rampwiz', participants: []),
    // Appointment(date: DateTime.now(), status: 2, approvedBy: 'Admin', location: 'Thoothukudi', raisedBy: 'Rampwiz', participants: []),
    // Appointment(date: DateTime.now(), status: 1, approvedBy: 'Admin', location: 'Thoothukudi', raisedBy: 'Rampwiz', participants: []),
    // Appointment(date: DateTime.now(), status: 1, approvedBy: 'Admin', location: 'Thoothukudi', raisedBy: 'Rampwiz', participants: []),
    // Appointment(date: DateTime.now(), status: 2, approvedBy: 'Admin', location: 'Thoothukudi', raisedBy: 'Rampwiz', participants: []),
    // Appointment(date: DateTime.now(), status: 1, approvedBy: 'Admin', location: 'Thoothukudi', raisedBy: 'Rampwiz', participants: []),
    // Appointment(date: DateTime.now(), status: 1, approvedBy: 'Admin', location: 'Thoothukudi', raisedBy: 'Rampwiz', participants: []),
    // Appointment(date: DateTime.now(), status: 2, approvedBy: 'Admin', location: 'Thoothukudi', raisedBy: 'Rampwiz', participants: []),
    // Appointment(date: DateTime.now(), status: 1, approvedBy: 'Admin', location: 'Thoothukudi', raisedBy: 'Rampwiz', participants: []),
  ];

  @override
  Widget build(BuildContext context) {
    var sourcelist = AppointmentSource(
      source,
      context,
    );

    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(isMobile(context) ? 2 : 8),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: isMobile(context) ? getWidth(context) * 3 : getWidth(context) * 0.80,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: isMobile(context) ? MainAxisAlignment.start : MainAxisAlignment.end,
                        children: [
                          const Text(''),
                          (auth.isAdmin ?? false)
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Get.to(const AppointmentPage());
                                      },
                                      child: const Text("Add")),
                                )
                              : Container(),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {});
                              },
                              child: const Text("Refresh"))
                        ],
                      ),
                    ),
                  ),
                ),
                StreamBuilder<List<Appointment>>(
                    stream: getAppointmentsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
                        var appointments = snapshot.data ?? [];
                        if (status != null) {
                          appointments = appointments.where((element) => element.status == status).toList();
                        }

                        appointments = appointments.where((element) => element.date.isAfter(fromDate)).toList();

                        appointments = appointments.where((element) => element.date.isBefore(toDate)).toList();

                        sourcelist = AppointmentSource(appointments, context);

                        return Table(
                          children: [
                            TableRow(
                              children: [
                                PaginatedDataTable(
                                  header: const Text("APPOINTMENTS"),
                                  actions: [
                                    SizedBox(
                                        width: 150,
                                        child: ListTile(
                                          title: DropdownButtonFormField<AppointmentStatus>(
                                              value: status,
                                              items: getAppointmentMenuItems(),
                                              onChanged: (val) {
                                                setState(() {
                                                  status = val;
                                                });
                                              }),
                                        )),
                                    SizedBox(
                                        width: 200,
                                        child: ListTile(
                                          title: TextFormField(
                                            controller: fromDateControler,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                    onPressed: () async {
                                                      var date = await showDatePicker(
                                                          context: context,
                                                          initialDate: fromDate,
                                                          firstDate: DateTime(2000),
                                                          lastDate: DateTime(2100));
                                                      setState(() {
                                                        fromDate = date ?? fromDate;
                                                        fromDateControler.text = fromDate.toString().substring(0, 10);
                                                      });
                                                    },
                                                    icon: const Icon(Icons.calendar_month))),
                                          ),
                                        )),
                                    SizedBox(
                                        width: 200,
                                        child: ListTile(
                                          title: TextFormField(
                                            controller: toDateControler,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                    onPressed: () async {
                                                      var date = await showDatePicker(
                                                          context: context, initialDate: toDate, firstDate: DateTime(2000), lastDate: DateTime(2100));
                                                      setState(() {
                                                        toDate = date ?? toDate;
                                                        toDateControler.text = toDate.toString().substring(0, 10);
                                                      });
                                                    },
                                                    icon: const Icon(Icons.calendar_month))),
                                          ),
                                        ))
                                  ],
                                  dragStartBehavior: DragStartBehavior.start,
                                  columns: AppointmentSource.getCoumns(),
                                  source: sourcelist,
                                  rowsPerPage: (getHeight(context) ~/ kMinInteractiveDimension) - 5,
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(child: SelectableText(snapshot.error.toString()));
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ],
            ),
          )),
    );
  }

  Stream<List<Appointment>> getAppointmentsStream() {
    if (auth.isAdmin ?? false) {
      return firestore
          .collection('appointments')
          .orderBy('date', descending: true)
          .snapshots()
          .map((event) => event.docs.map((e) => Appointment.fromJson(e.data(), e.reference.id)).toList());
    } else {
      return firestore
          .collection('appointments')
          .where('particpantsIcs', arrayContains: auth.currentUser?.uid ?? '')
          .orderBy('date', descending: true)
          .snapshots()
          .map((event) => event.docs.map((e) => Appointment.fromJson(e.data(), e.reference.id)).toList());
    }
  }
}
