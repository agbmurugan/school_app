import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_app/constants/get_constants.dart';
import 'package:school_app/controllers/Attendance%20API/trnasaction_controller.dart';
import 'package:school_app/models/biodata.dart';
import 'package:school_app/screens/list/student_list.dart';

class BioAttendnace extends StatefulWidget {
  const BioAttendnace({Key? key, required this.entity}) : super(key: key);

  final Bio entity;

  @override
  State<BioAttendnace> createState() => _BioAttendnaceState();
}

class _BioAttendnaceState extends State<BioAttendnace> {
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final format = DateFormat.yMMMd('en_US');

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    toDate = DateTime(now.year, now.month, now.day, 23, 59);
    fromDate = DateTime(toDate.year, toDate.month, 1);
    fromDateController.text = format.format(fromDate);
    toDateController.text = format.format(toDate);
  }

  late DateTime toDate;
  late DateTime fromDate;
  Widget getTextFormField(bool isFromDate) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: isMobile(context) ? 100 : 200,
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
                        fromDateController.text = format.format(date);
                        fromDate = date;
                      });
                    } else {
                      setState(() {
                        toDateController.text = format.format(date);
                        toDate = date;
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_month))),
        ),
      ),
    );
  }

  CheckInStatus? _checkInStatus;
  CheckOutStatus? _checkOutStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.entity.name), actions: const []),
      body: Column(children: [
        SizedBox(
          height: 120,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Hero(
                  tag: widget.entity.icNumber,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: (widget.entity.imageUrl != null ? NetworkImage(widget.entity.imageUrl!) : const AssetImage('assets/logo.png'))
                        as ImageProvider,
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      getTextFormField(true),
                      getTextFormField(false),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(child: SingleChildScrollView(
          child: Builder(builder: (context) {
            Map<String, dynamic> mapParams = {
              'empCode': widget.entity.docId,
              'startTime': fromDate,
              'endTime': toDate,
            };
            return FutureBuilder<List<StudentAttendanceByDate>>(
              // future: TransactionController.loadTransactions(empCode: widget.student.icNumber, startTime: fromDate, endTime: toDate),
              future: compute(TransactionController.loadEmpTransactions, mapParams),
              builder: (BuildContext context, AsyncSnapshot<List<StudentAttendanceByDate>> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: SelectableText(snapshot.error.toString()),
                  );
                }
                if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                  var attendanceLogs = snapshot.data ?? [];

                  if (_checkInStatus != null) {
                    attendanceLogs = attendanceLogs.where((element) => element.checkInStatus == _checkInStatus).toList();
                  }
                  if (_checkOutStatus != null) {
                    attendanceLogs = attendanceLogs.where((element) => element.checkOutStatus == _checkOutStatus).toList();
                  }

                  return Table(
                    children: [
                      TableRow(
                        children: [
                          PaginatedDataTable(
                              header: const Text('INDIVIDUAL ATTENDANCE REPORT'),
                              actions: [
                                SizedBox(
                                  width: 150,
                                  child: DropdownButtonFormField<CheckInStatus?>(
                                      items: const [
                                        DropdownMenuItem(
                                          child: Text("ALL"),
                                          value: null,
                                        ),
                                        DropdownMenuItem(child: Text("ON TIME"), value: CheckInStatus.onTime),
                                        DropdownMenuItem(child: Text("LATE"), value: CheckInStatus.late),
                                      ],
                                      onChanged: (val) {
                                        setState(() {
                                          _checkInStatus = val;
                                        });
                                      }),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: DropdownButtonFormField<CheckOutStatus?>(
                                      items: const [
                                        DropdownMenuItem(
                                          child: Text("ALL"),
                                          value: null,
                                        ),
                                        DropdownMenuItem(child: Text("ON TIME"), value: CheckOutStatus.onTime),
                                        DropdownMenuItem(child: Text("LATE"), value: CheckOutStatus.early),
                                      ],
                                      onChanged: (val) {
                                        _checkOutStatus = val;
                                      }),
                                )
                              ],
                              columns: AttendanceSource.getCoumns(),
                              source: AttendanceSource(context: context, logs: attendanceLogs)),
                        ],
                      ),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          }),
        ))
      ]),
    );
  }
}

class AttendanceSource extends DataTableSource {
  final BuildContext context;
  final List<StudentAttendanceByDate> logs;
  final String? area;

  final format = DateFormat.MMMd('en_US');

  AttendanceSource({required this.context, required this.logs, this.area});
  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= logs.length) return null;
    final log = logs[index];

    var cells = [
      DataCell(Text(format.format(log.date))),
      DataCell(Text(log.checkInTime == null ? 'NO DATA' : TimeOfDay.fromDateTime(log.checkInTime!).format(context))),
      DataCell(Text(log.checkInStatus == null ? 'NO DATA' : log.checkInStatus.toString().split('.').last.toUpperCase())),
      DataCell(Text(log.checkOutTime == null ? 'NO DATA' : TimeOfDay.fromDateTime(log.checkOutTime!).format(context))),
      DataCell(Text(log.checkOutStatus == null ? 'NO DATA' : log.checkOutStatus.toString().split('.').last.toUpperCase())),
      DataCell(Text(log.cafeteria ? 'CHECKED IN' : 'NOT CHECKED IN')),
    ];
    if (area == 'CAFETERIA') {
      cells.removeLast();
    }

    return DataRow(cells: cells, color: (index % 2 == 0) ? MaterialStateProperty.all(Colors.grey.shade200) : MaterialStateProperty.all(Colors.white));
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => logs.length;

  @override
  int get selectedRowCount => 0;

  static List<DataColumn> getCoumns() {
    List<DataColumn> columns = [
      const DataColumn(label: Text('DATE')),
      const DataColumn(label: Text('CHECK IN')),
      const DataColumn(label: Text('CHECK IN STATUS')),
      const DataColumn(label: Text('CHECK OUT')),
      const DataColumn(label: Text('CHECK OUT STATUS')),
      const DataColumn(label: Text('CAFETERIA')),
    ];
    return columns;
  }
}
