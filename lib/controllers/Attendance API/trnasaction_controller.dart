import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:school_app/constants/constant.dart';
import 'package:school_app/controllers/attendance_controller.dart';
import 'package:school_app/models/Attendance/transaction.dart';
import 'package:school_app/screens/list/student_list.dart';

class TransactionController {
  static Future<List<TransactionLog>> loadTransactions({DateTime? startTime, DateTime? endTime, String? empCode, required int? entity}) {
    List<TransactionLog> transactionLogs = [];

    var callable = functions.httpsCallable('getTransaction', options: HttpsCallableOptions(timeout: const Duration(seconds: 15)));
    var data = {
      'token': AttendanceController.token,
      'start_time': startTime?.toString().substring(0, 19),
      'end_time': endTime?.toString().substring(0, 19),
      'emp_code': empCode,
      'entity': entity
    };
    return callable.call(data).then((response) {
      var value = response.data;
      if (value is List) {
        transactionLogs = value.map((e) => TransactionLog.fromJson(e)).toList();
      }
      print("Transaction Length  : ${transactionLogs.length}");
      return transactionLogs;
    });
  }

  static Future<List<StudentAttendanceByDate>> loadEmpTransactions(Map<String, dynamic> paramsMap) {
    DateTime startTime = paramsMap['startTime'];
    DateTime endTime = paramsMap['endTime'];
    String empCode = paramsMap['empCode'];
    int? entity = paramsMap['entity'];
    List<StudentAttendanceByDate> transactionLogs = [];
    var callable = functions.httpsCallable('getTransaction', options: HttpsCallableOptions(timeout: const Duration(seconds: 5)));
    var data = {
      'token': AttendanceController.token,
      'start_time': startTime.toString().substring(0, 19),
      'end_time': endTime.toString().substring(0, 19),
      'emp_code': empCode,
      'entity': entity
    };
    return callable.call(data).then((response) {
      var value = response.data;
      if (value is List) {
        print(value);
        var logs = value.map((e) => TransactionLog.fromJson(e)).toList();
        var diffInDays = endTime.difference(startTime).inDays + 1;
        for (int i = 0; i < diffInDays; i++) {
          var date = startTime.add(Duration(days: i));
          // print(date.toString());
          DateTime? checkInTime;
          DateTime? checkOutTime;
          bool cafeteria = false;
          var tempLogs;
          try {
            tempLogs = logs.where((element) => element.punchDate == date).toList();
          } catch (e) {
            print(e.toString());
          }
          for (var tempLog in tempLogs) {
            if (tempLog.areaAlias != 'CAFETERIA') {
              cafeteria = true;
              if (tempLog.punchState == '0') {
                checkInTime = checkInTime == null
                    ? tempLog.punchTime
                    : checkInTime.isBefore(tempLog.punchTime)
                        ? checkInTime
                        : tempLog.punchTime;
              }
              if (tempLog.punchState == '1') {
                checkOutTime = checkOutTime == null
                    ? tempLog.punchTime
                    : checkOutTime.isAfter(tempLog.punchTime)
                        ? checkOutTime
                        : tempLog.punchTime;
              }
            }
          }
          transactionLogs.add(StudentAttendanceByDate(date: date, checkInTime: checkInTime, checkOutTime: checkOutTime, cafeteria: cafeteria));
        }
      } else {
        // print('ERROR');
      }
      return transactionLogs;
    });
  }
}

class StudentAttendanceByDate {
  final DateTime date;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final bool cafeteria;

  CheckInStatus? get checkInStatus {
    if (checkInTime != null) {
      var duration = checkInTime!.difference(DateTime(checkInTime!.year, checkInTime!.month, checkInTime!.day, 9, 0));
      if (duration.inMinutes < 0) {
        return CheckInStatus.onTime;
      } else {
        return CheckInStatus.late;
      }
    }
    return null;
  }

  CheckOutStatus? get checkOutStatus {
    if (checkOutTime != null) {
      var duration = checkOutTime!.difference(DateTime(checkOutTime!.year, checkOutTime!.month, checkOutTime!.day, 16, 30));
      if (duration.inMinutes > 0) {
        return CheckOutStatus.onTime;
      } else {
        return CheckOutStatus.early;
      }
    }
    return null;
  }

  StudentAttendanceByDate({
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
    required this.cafeteria,
  });
}
