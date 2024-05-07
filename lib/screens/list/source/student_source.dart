import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school_app/constants/constant.dart';
import 'package:school_app/constants/get_constants.dart';
import 'package:school_app/controllers/attendance_controller.dart';
import 'package:school_app/models/Attendance/transaction.dart';
import 'package:school_app/screens/Form/student_form.dart';
import 'package:school_app/screens/list/attendance_list.dart';
import 'package:school_app/screens/list/student_list.dart';
import '../../../models/biodata.dart';

class StudentSource extends DataTableSource {
  final List<StudentTransaction> students;
  final BuildContext context;
  final void Function(void Function()) setstate;
  StudentSource(
    this.students,
    this.context,
    this.setstate,
  );

  final timeFormat = DateFormat.jm();

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= students.length) return null;
    final studentTransaction = students[index];
    final entity = studentTransaction.student;
    print("While Clicking edit ${entity.toJson()}");
    int sNo = index + 1;

    return DataRow.byIndex(
        index: index,
        color: MaterialStateProperty.all((sNo % 2 == 0) ? Colors.white : const Color.fromARGB(255, 233, 232, 232)),
        cells: [
          DataCell(Text(sNo.toString())),
          DataCell((entity.imageUrl ?? '').isEmpty
              ? const CircleAvatar(
                  child: Text("IMG"),
                )
              : CircleAvatar(
                  backgroundImage: NetworkImage(entity.imageUrl!),
                )),
          DataCell(Text(entity.name)),
          DataCell(Text(entity.icNumber)),
          DataCell(Text(entity.gender.name.toString().toUpperCase())),
          DataCell(Text(studentTransaction.checkInStatus == null ? 'NO DATA' : timeFormat.format(studentTransaction.checkInTime!))),
          DataCell(Text(studentTransaction.checkOutStatus == null ? 'NO DATA' : timeFormat.format(studentTransaction.checkOutTime!))),
          DataCell(Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 32),
              child: IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        int index = 0;
                        return Dialog(
                          child: BioAttendnace(entity: entity),
                        );
                      });
                },
              ),
            ),
          )),
          DataCell(IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              var future = entity.controller.delete().then((value) {
                functions.httpsCallable('deleteEmployee').call({'token': AttendanceController.token, 'emp_code': entity.docId});
                setstate(() {
                  students.removeWhere((element) => element.student == entity);
                });
              });
              showDialog(
                  context: context,
                  builder: (context) {
                    return FutureBuilder(
                      future: future,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                          return AlertDialog(
                            title: const Text("Student Deleted"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Okay"))
                            ],
                          );
                        }

                        if (snapshot.hasError) {
                          return AlertDialog(
                            title: const Text("Error occured"),
                            content: Text(snapshot.error.toString()),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Okay"))
                            ],
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                  });
            },
          )),
          DataCell(IconButton(
              onPressed: () {
                Get.to(() => StudentForm(student: entity));
              },
              icon: const Icon(Icons.edit))),
        ]);
  }

  static List<DataColumn> getCoumns(EntityType entity) {
    List<DataColumn> columns = [
      const DataColumn(label: Text('SINO')),
      const DataColumn(label: Text('PROFILE')),
      const DataColumn(label: Text('NAME')),
      const DataColumn(label: Text('IC NUMBER')),
      // const DataColumn(label: Text('EMAIL')),
      const DataColumn(label: Text('GENDER')),
      const DataColumn(label: Text('CHECK IN')),
      const DataColumn(label: Text('CHECK OUT')),
      const DataColumn(
        label: Center(child: Text('ATTENDANCE REPORT')),
      ),
      const DataColumn(label: Text('DELETE')),
      const DataColumn(label: Text('EDIT')),
    ];

    return columns;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => students.length;

  @override
  int get selectedRowCount => 0;
}

class AttendanceLogSource extends DataTableSource {
  final BuildContext context;
  final List<TransactionLog> logs;
  final String? area;

  AttendanceLogSource(this.context, this.logs, this.area);

  bool status(DateTime date) {
    var statrTime = DateTime(date.year, date.month, date.day, 9, 26);
    return statrTime.isAfter(date);
  }

  final _format = DateFormat.yMMMMd('en_US');

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= logs.length) return null;
    final log = logs[index];

    var cells = [
      DataCell(Text((index + 1).toString())),
      DataCell(Text(_format.format(log.punchTime))),
      DataCell(Text(TimeOfDay.fromDateTime(log.punchTime).format(context))),
      DataCell(Text(log.punchStateDisplay.toString())),
      DataCell(Text(status(log.punchTime) ? "ON-TIME" : "LATE")),
    ];
    if (area == 'CAFETERIA') {
      cells.removeLast();
    }

    return DataRow(cells: cells);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => logs.length;

  @override
  int get selectedRowCount => 0;

  static List<DataColumn> getCoumns(String? area) {
    List<DataColumn> columns = [
      const DataColumn(label: Text('SINO')),
      const DataColumn(label: Text('DATE')),
      const DataColumn(label: Text('PUNCH TIME')),
      const DataColumn(label: Text('PUNCH STATE')),
      const DataColumn(label: Text('STATUS')),
    ];
    if (area == 'CAFETERIA') {
      columns.removeLast();
    }
    return columns;
  }
}

class AttendanceTable extends StatefulWidget {
  const AttendanceTable({Key? key, required this.logs, required this.area}) : super(key: key);

  final List<TransactionLog> logs;
  final String area;

  @override
  State<AttendanceTable> createState() => _AttendanceTableState();
}

class _AttendanceTableState extends State<AttendanceTable> {
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  @override
  void initState() {
    var today = DateTime.now();
    fromDate = DateTime(today.year, today.month, today.day);
    toDate = fromDate.add(const Duration(days: 1));
    fromDateController.text = _format.format(fromDate);
    toDateController.text = _format.format(toDate);
    super.initState();
  }

  final _format = DateFormat.yMMMMd('en_US');

  late DateTime toDate;
  late DateTime fromDate;
  Widget getTextFormField(bool isFromDate) {
    return SizedBox(
      width: isMobile(context) ? 100 : 300,
      child: TextFormField(
        controller: isFromDate ? fromDateController : toDateController,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () async {
              DateTime date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  ) ??
                  (isFromDate ? fromDate : toDate);

              if (isFromDate) {
                setState(() {
                  fromDateController.text = _format.format(date);
                  fromDate = date;
                });
              } else {
                setState(() {
                  toDateController.text = _format.format(date);
                  toDate = date;
                });
              }
            },
            icon: const Icon(Icons.calendar_month),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var source = AttendanceLogSource(context, widget.logs, widget.area);
    return PaginatedDataTable(
      header: const Text(''),
      actions: [
        getTextFormField(true),
        getTextFormField(false),
      ],
      columns: AttendanceLogSource.getCoumns(widget.area),
      source: source,
    );
  }
}
