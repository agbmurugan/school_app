// import 'package:flutter/foundation.dart';
import 'package:school_app/screens/list/student_list.dart';
import 'package:school_app/screens/list/teacher_list.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
// import 'dart:convert';
// import 'package:universal_html/html.dart' show AnchorElement;

class ExcelService {
  static Future<List<int>> createStudentsReport(List<StudentTransaction> studentTransactions) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A1').setText('NAME');
    sheet.getRangeByName('B1').setText('IC NUMBER');
    sheet.getRangeByName('C1').setText('GENDER');
    sheet.getRangeByName('D1').setText('CHECK IN');
    sheet.getRangeByName('E1').setText('CHECK IN STATUS');
    sheet.getRangeByName('F1').setText('CHECK OUT');
    sheet.getRangeByName('G1').setText('CHECK OUT STATUS');
    sheet.getRangeByName('H1').setText('FATHER NAME');
    sheet.getRangeByName('I1').setText('FATHER IC');
    sheet.getRangeByName('J1').setText('FATHER EMAIL');
    sheet.getRangeByName('K1').setText('FATHER GENDER');
    sheet.getRangeByName('L1').setText('FATHER ADDRESS');
    sheet.getRangeByName('M1').setText('MOTHER NAME');
    sheet.getRangeByName('N1').setText('MOTHER IC');
    sheet.getRangeByName('O1').setText('MOTHER EMAIL');
    sheet.getRangeByName('P1').setText('MOTHER GENDER');
    sheet.getRangeByName('Q1').setText('MOTHER ADDRESS');
    sheet.getRangeByName('R1').setText('GUARDIAN NAME');
    sheet.getRangeByName('S1').setText('GUARDIAN IC');
    sheet.getRangeByName('T1').setText('GUARDIAN EMAIL');
    sheet.getRangeByName('U1').setText('GUARDIAN GENDER');
    sheet.getRangeByName('V1').setText('GUARDIAN ADDRESS');

    for (int i = 0; i < studentTransactions.length; i++) {
      var studentTransaction = studentTransactions[i];
      sheet.getRangeByName('A${i + 2}').setText(studentTransaction.student.name.toUpperCase());
      sheet.getRangeByName('B${i + 2}').setText(studentTransaction.student.icNumber);
      sheet.getRangeByName('C${i + 2}').setText(studentTransaction.student.gender.toString().toUpperCase());
      sheet
          .getRangeByName('D${i + 2}')
          .setText(studentTransaction.checkInTime == null ? "NO DATA" : studentTransaction.checkInTime.toString().substring(0, 19));
      sheet
          .getRangeByName('E${i + 2}')
          .setText(studentTransaction.checkInStatus == null ? "NO DATA" : studentTransaction.checkInStatus.toString().toUpperCase());
      sheet
          .getRangeByName('F${i + 2}')
          .setText(studentTransaction.checkOutTime == null ? "NO DATA" : studentTransaction.checkOutTime.toString().substring(0, 19));
      sheet
          .getRangeByName('G${i + 2}')
          .setText(studentTransaction.checkOutStatus == null ? "NO DATA" : studentTransaction.checkOutStatus.toString().toUpperCase());
      var letter = 72;
      sheet.getRangeByName('H${i + 2}').setText(studentTransaction.student.father?.name.toString().toUpperCase());
      sheet.getRangeByName('I${i + 2}').setText(studentTransaction.student.father?.icNumber.toString().toUpperCase());
      sheet.getRangeByName('J${i + 2}').setText(studentTransaction.student.father?.email.toString().toUpperCase());
      sheet.getRangeByName('K${i + 2}').setText(studentTransaction.student.father?.gender.toString().toUpperCase());
      sheet.getRangeByName('L${i + 2}').setText(studentTransaction.student.father?.address.toString().toUpperCase());
      sheet.getRangeByName('M${i + 2}').setText(studentTransaction.student.mother?.name.toString().toUpperCase());
      sheet.getRangeByName('N${i + 2}').setText(studentTransaction.student.mother?.icNumber.toString().toUpperCase());
      sheet.getRangeByName('O${i + 2}').setText(studentTransaction.student.mother?.email.toString().toUpperCase());
      sheet.getRangeByName('P${i + 2}').setText(studentTransaction.student.mother?.gender.toString().toUpperCase());
      sheet.getRangeByName('Q${i + 2}').setText(studentTransaction.student.mother?.address.toString().toUpperCase());
      sheet.getRangeByName('R${i + 2}').setText(studentTransaction.student.guardian?.name.toString().toUpperCase());
      sheet.getRangeByName('S${i + 2}').setText(studentTransaction.student.guardian?.icNumber.toString().toUpperCase());
      sheet.getRangeByName('T${i + 2}').setText(studentTransaction.student.guardian?.email.toString().toUpperCase());
      sheet.getRangeByName('U${i + 2}').setText(studentTransaction.student.guardian?.gender.toString().toUpperCase());
      sheet.getRangeByName('V${i + 2}').setText(studentTransaction.student.guardian?.address.toString().toUpperCase());
    }

    for (int i = 1; i <= 30; i++) {
      sheet.autoFitColumn(i);
    }
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    // if (kIsWeb) {
    //   AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64, ${base64.encode(bytes)}')
    //     ..setAttribute('download', 'export.xlsx')
    //     ..click();
    // }
    return bytes;
  }

  static Future<List<int>> createTeachersReport(List<TeacherTransaction> teacherTransactions) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A1').setText('NAME');
    sheet.getRangeByName('B1').setText('IC NUMBER');
    sheet.getRangeByName('C1').setText('GENDER');
    sheet.getRangeByName('D1').setText('CHECK IN');
    sheet.getRangeByName('E1').setText('CHECK IN STATUS');
    sheet.getRangeByName('F1').setText('CHECK OUT');
    sheet.getRangeByName('G1').setText('CHECK OUT STATUS');

    for (int i = 0; i < teacherTransactions.length; i++) {
      var teacherTransaction = teacherTransactions[i];
      sheet.getRangeByName('A${i + 2}').setText(teacherTransaction.teacher.name.toUpperCase());
      sheet.getRangeByName('B${i + 2}').setText(teacherTransaction.teacher.icNumber);
      sheet.getRangeByName('C${i + 2}').setText(teacherTransaction.teacher.gender.toString().toUpperCase());
      sheet
          .getRangeByName('D${i + 2}')
          .setText(teacherTransaction.checkInTime == null ? "NO DATA" : teacherTransaction.checkInTime.toString().substring(0, 19));
      sheet
          .getRangeByName('E${i + 2}')
          .setText(teacherTransaction.checkInStatus == null ? "NO DATA" : teacherTransaction.checkInStatus.toString().toUpperCase());
      sheet
          .getRangeByName('F${i + 2}')
          .setText(teacherTransaction.checkOutTime == null ? "NO DATA" : teacherTransaction.checkOutTime.toString().substring(0, 19));
      sheet
          .getRangeByName('G${i + 2}')
          .setText(teacherTransaction.checkOutStatus == null ? "NO DATA" : teacherTransaction.checkOutStatus.toString().toUpperCase());
    }

    for (int i = 1; i <= 30; i++) {
      sheet.autoFitColumn(i);
    }
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    // if (kIsWeb) {
    //   AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64, ${base64.encode(bytes)}')
    //     ..setAttribute('download', 'export.xlsx')
    //     ..click();
    // }
    return bytes;
  }
}
