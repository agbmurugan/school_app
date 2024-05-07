// To parse this JSON data, do
//
//     final transaction = transactionFromJson(jsonString);

import 'dart:convert';

import 'package:school_app/screens/list/student_list.dart';

TransactionLog transactionFromJson(String str) => TransactionLog.fromJson(json.decode(str));

String transactionToJson(TransactionLog data) => json.encode(data.toJson());

class TransactionLog {
  TransactionLog({
    required this.id,
    required this.empCode,
    required this.firstName,
    this.lastName,
    this.department,
    this.position,
    required this.punchTime,
    required this.punchState,
    this.punchStateDisplay,
    this.verifyType,
    this.verifyTypeDisplay,
    this.workCode,
    this.gpsLocation,
    this.areaAlias,
    this.terminalSn,
    this.temperature,
    this.terminalAlias,
    required this.uploadTime,
  });

  int id;
  String empCode;
  String firstName;
  String? lastName;
  String? department;
  String? position;
  DateTime punchTime;
  String punchState;
  String? punchStateDisplay;
  int? verifyType;
  String? verifyTypeDisplay;
  String? workCode;
  String? gpsLocation;
  dynamic areaAlias;
  String? terminalSn;
  int? temperature;
  dynamic terminalAlias;
  DateTime uploadTime;
  DateTime get punchDate => DateTime(punchTime.year, punchTime.month, punchTime.day);

  CheckInStatus? get checkInStatus {
    if (punchState == '0') {
      var duration = punchTime.difference(DateTime(punchTime.year, punchTime.month, punchTime.day, 9, 0));
      if (duration.inMinutes < 0) {
        return CheckInStatus.onTime;
      } else {
        return CheckInStatus.late;
      }
    }
    return null;
  }

  CheckOutStatus? get checkOutStatus {
    if (punchState == '1') {
      var duration = punchTime.difference(DateTime(punchTime.year, punchTime.month, punchTime.day, 16, 30));
      if (duration.inMinutes > 0) {
        return CheckOutStatus.onTime;
      } else {
        return CheckOutStatus.early;
      }
    }
    return null;
  }

  factory TransactionLog.fromJson(Map<String, dynamic> json) => TransactionLog(
        id: json["id"],
        empCode: json["emp_code"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        department: json["department"] ?? json["dept_code"],
        position: json["position"],
        punchTime: DateTime.parse(json["punch_time"]),
        punchState: json["punch_state"],
        punchStateDisplay: json["punch_state_display"],
        verifyType: json["verify_type"],
        verifyTypeDisplay: json["verify_type_display"],
        workCode: json["work_code"],
        gpsLocation: json["gps_location"],
        areaAlias: json["area_alias"],
        terminalSn: json["terminal_sn"],
        temperature: json["temperature"],
        terminalAlias: json["terminal_alias"],
        uploadTime: DateTime.parse(json["upload_time"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "emp_code": empCode,
        "first_name": firstName,
        "last_name": lastName,
        "department": department,
        "position": position,
        "punch_time": punchTime.toIso8601String(),
        "punch_state": punchState,
        "punch_state_display": punchStateDisplay,
        "verify_type": verifyType,
        "verify_type_display": verifyTypeDisplay,
        "work_code": workCode,
        "gps_location": gpsLocation,
        "area_alias": areaAlias,
        "terminal_sn": terminalSn,
        "temperature": temperature,
        "terminal_alias": terminalAlias,
        "upload_time": uploadTime.toString(),
      };
}
