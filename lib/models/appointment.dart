import 'dart:async';

import 'package:flutter/material.dart';
import 'package:school_app/constants/constant.dart';
import 'package:school_app/controllers/auth_controller.dart';
import 'package:school_app/models/parent.dart';
import 'package:school_app/models/response.dart';

import 'biodata.dart';

enum AppointmentStatus { pending, approved, cancelled, finished }

class Appointment {
  Appointment({
    required this.date,
    this.approvedBy,
    required this.location,
    this.raisedBy,
    required this.participants,
    required this.purpose,
    required this.fromTime,
    required this.toTime,
    required this.parent,
    this.id,
    this.adminApproval = false,
    this.parentApproval = false,
  });

  DateTime date;
  String? id;
  String purpose;
  AppointmentStatus get status {
    if (date.isBefore(DateTime.now())) {
      if (adminApproval && parentApproval) {
        return AppointmentStatus.finished;
      } else {
        return AppointmentStatus.cancelled;
      }
    } else {
      if (adminApproval && parentApproval) {
        return AppointmentStatus.approved;
      } else {
        return AppointmentStatus.pending;
      }
    }
  }

  Parent parent;
  TimeOfDay fromTime;
  TimeOfDay toTime;
  String? approvedBy;
  bool adminApproval;
  bool parentApproval;
  String? raisedBy;
  String? location;
  List<dynamic> participants;

  factory Appointment.fromJson(Map<String, dynamic> json, id) => Appointment(
        id: id,
        date: json["date"].toDate(),
        approvedBy: json["approvedBy"],
        location: json["location"],
        participants: json["participants"].map((e) => Bio.fromBioJson(e)).toList(),
        raisedBy: json["raisedBy"],
        purpose: json["purpose"],
        fromTime: TimetoJson.fromJson(json["fromTime"]),
        toTime: TimetoJson.fromJson(json["toTime"]),
        parent: Parent.fromJson(json["parent"]),
        adminApproval: json["adminApproval"] ?? false,
        parentApproval: json["parentApproval"] ?? false,
      );

  Map<String, dynamic> toJson() {
    var json = {
      "id": id,
      "date": date,
      "status": status.index,
      "approvedBy": approvedBy,
      "location": location,
      "participants": participants.map((e) => e.toBioJson()).toList(),
      "raisedBy": raisedBy,
      "purpose": purpose,
      "fromTime": fromTime.toJson(),
      "toTime": toTime.toJson(),
      "particpantsIcs": participants.map((e) => (e as Bio).icNumber).toList(),
      "parent": parent.toJson(),
      "adminApproval": adminApproval,
      "parentApproval": parentApproval,
    };
    for (Bio element in participants) {
      json.addAll({
        element.icNumber: true,
      });
    }
    return json;
  }

  FutureOr<Result> approve() {
    approvedBy = auth.currentUser!.uid;
    return update();
  }

  Future<Result> update() {
    return firestore
        .collection('appointments')
        .doc(id)
        .update(toJson())
        .then((value) => Result.success("Updated Successfully"))
        .onError((error, stackTrace) => Result.error(error.toString()));
  }
}

extension TimetoJson on TimeOfDay {
  Map<String, dynamic> toJson() => {
        "hour": hour,
        "minute": minute,
      };
  static TimeOfDay fromJson(json) {
    return TimeOfDay(hour: json["hour"], minute: json["minute"]);
  }
}
