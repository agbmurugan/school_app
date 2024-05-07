import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school_app/constants/constant.dart';
import 'package:school_app/controllers/attendance_controller.dart';
import 'package:school_app/screens/Form/teacher_form.dart';
import 'package:school_app/screens/list/attendance_list.dart';
import '../teacher_list.dart';

class TeacherSource extends DataTableSource {
  final List<TeacherTransaction> teachers;
  final BuildContext context;
  final StateSetter? setstate;
  TeacherSource(this.teachers, this.context, this.setstate);

  final timeFormat = DateFormat.jm();

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= teachers.length) return null;
    final teacherTransaction = teachers[index];
    final entity = teacherTransaction.teacher;
    int sNo = index + 1;

    return DataRow.byIndex(
        index: index,
        color: MaterialStateProperty.all((sNo % 2 == 0) ? Colors.white : Color.fromARGB(255, 233, 232, 232)),
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
          DataCell(Text(teacherTransaction.checkInStatus == null ? 'NO DATA' : timeFormat.format(teacherTransaction.checkInTime!))),
          DataCell(Text(teacherTransaction.checkOutStatus == null ? 'NO DATA' : timeFormat.format(teacherTransaction.checkOutTime!))),
          DataCell(IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    int index = 0;
                    return BioAttendnace(entity: entity);
                  });
            },
          )),
          DataCell(IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              entity.controller.delete().then((value) {
                if (setstate != null) {
                  setstate!(() {
                    teachers.remove(teacherTransaction);
                  });
                  functions.httpsCallable('deleteEmployee').call({'token': AttendanceController.token, 'emp_code': entity.icNumber});
                }
              });
            },
          )),
          DataCell(IconButton(
              onPressed: () {
                Get.to(() => TeacherForm(teacher: entity));
              },
              icon: const Icon(Icons.edit))),
        ]);
  }

  static List<DataColumn> getCoumns() {
    List<DataColumn> columns = [
      const DataColumn(label: Text('SINO')),
      const DataColumn(label: Text('PROFILE')),
      const DataColumn(label: Text('NAME')),
      const DataColumn(label: Text('IC NUMBER')),
      // const DataColumn(label: Text('EMAIL')),
      const DataColumn(label: Text('GENDER')),
      const DataColumn(label: Text('CHECK IN')),
      const DataColumn(label: Text('CHECK OUT')),
      const DataColumn(label: Text('ATTENDANCE REPORT')),
      const DataColumn(label: Text('DELETE')),
      const DataColumn(label: Text('EDIT')),
    ];

    return columns;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => teachers.length;

  @override
  int get selectedRowCount => 0;
}
