import 'package:flutter/material.dart';
import 'package:school_app/constants/get_constants.dart';
import 'package:school_app/controllers/appointment_controller.dart';
import 'package:school_app/models/appointment.dart';

import '../../Form/appointment_form.dart';

class AppointmentSource extends DataTableSource {
  final BuildContext context;
  List<Appointment> appointments;

  AppointmentSource(
    this.appointments,
    this.context,
  );

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= appointments.length) return null;
    var appointment = appointments[index];
    // final CRUD object = getEntity(entity);
    int sNo = index + 1;

    return DataRow.byIndex(
        index: index,
        color: MaterialStateProperty.all((sNo % 2 == 0) ? Colors.white : Color.fromARGB(255, 233, 232, 232)),
        cells: [
          DataCell(Text(sNo.toString())),
          DataCell(Text(appointment.purpose)),
          DataCell(Text(appointment.parent.name)),
          DataCell(Text(appointment.date.toString().substring(0, 10))),
          DataCell(Text(appointment.fromTime.format(context) + " : " + appointment.toTime.format(context))),
          DataCell(Text(appointment.parentApproval ? "Accepted" : "Pending")),
          DataCell(
            appointment.adminApproval
                ? const Text("Accepted")
                : ElevatedButton(
                    onPressed: () {
                      appointment.adminApproval = true;
                      // appointment.status =
                      //     (appointment.parentApproval && appointment.adminApproval) ? AppointmentStatus.approved : AppointmentStatus.pending;
                      appointment.approve();
                    },
                    child: const Text('Approve'),
                  ),
          ),
          DataCell(Text(appointment.status.toString().split('.').last.toUpperCase())),
          DataCell(appointment.adminApproval
              ? ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              content: SizedBox(
                                  width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.30,
                                  child: AppointmentPage(
                                    appointment: appointment,
                                  )));
                        });
                  },
                  child: const Text('Reschedule'),
                )
              : Container()),
          DataCell(IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              AppointmentController(appointment).delete();
            },
          )),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => appointments.length;

  @override
  int get selectedRowCount => 0;

  static List<DataColumn> getCoumns() {
    List<DataColumn> columns = [
      const DataColumn(label: Text('SINO')),
      const DataColumn(label: Text('TITLE')),
      const DataColumn(label: Text('PARENT')),
      const DataColumn(label: Text('DATE')),
      const DataColumn(label: Text('TIME')),
      const DataColumn(label: SizedBox(child: Center(child: Text('PARENT APPROVAL')))),
      const DataColumn(label: SizedBox(child: Center(child: Text('ADMIN APPROVAL')))),
      const DataColumn(label: Text('STATUS')),
      const DataColumn(
          label: Center(
              child: SizedBox(
                  width: 110,
                  child: Text(
                    'CONFIRMATION',
                    textAlign: TextAlign.center,
                  )))),
      const DataColumn(label: Text('DELETE'))
    ];

    return columns;
  }
}
