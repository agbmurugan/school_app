import 'package:flutter/material.dart';
import 'package:time_range/time_range.dart';

import '../../../models/appointment.dart';
import '../../../models/parent.dart';

class AppointmentFormController {
  DateTime date = DateTime.now();
  String? id;
  TextEditingController purpose = TextEditingController();
  AppointmentStatus status = AppointmentStatus.pending;
  TimeOfDay fromTime = const TimeOfDay(hour: 14, minute: 50);
  TimeOfDay toTime = const TimeOfDay(hour: 15, minute: 20);
  String? approvedBy;

  bool parentApproval = false;
  String? raisedBy;
  String? location;
  List<dynamic> participants = [];

  Parent? parent;
  bool adminApproval = true;
  AppointmentFormController();

  TimeRangeResult get timeRange => TimeRangeResult(
        fromTime,
        toTime,
      );

  Appointment get appointment => Appointment(
        date: DateTime(date.year, date.month, date.day, fromTime.hour, fromTime.minute),
        location: location,
        participants: participants,
        purpose: purpose.text,
        fromTime: fromTime,
        toTime: toTime,
        parent: parent!,
        adminApproval: adminApproval,
        approvedBy: approvedBy,
        id: id,
        parentApproval: parentApproval,
        raisedBy: raisedBy,
      );

  factory AppointmentFormController.fromAppointment(Appointment appointment) {
    var controller = AppointmentFormController();
    controller.date = appointment.date;
    controller.id = appointment.id;
    controller.purpose.text = appointment.purpose;
    controller.fromTime = appointment.fromTime;
    controller.toTime = appointment.toTime;
    controller.approvedBy = appointment.approvedBy;
    controller.parentApproval = appointment.parentApproval;
    controller.raisedBy = appointment.raisedBy;
    controller.participants = appointment.participants;
    controller.parent = appointment.parent;
    controller.adminApproval = appointment.adminApproval;
    controller.status = appointment.status;
    return controller;
  }
}
