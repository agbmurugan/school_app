import 'package:get/get.dart';
import '../constants/constant.dart';
import '../models/response.dart';
import '../models/appointment.dart';

class AppointmentController extends GetxController {
  AppointmentController(this.appointment);

  final Appointment appointment;
  static RxList<Appointment> appointmentList = <Appointment>[].obs;

  static String selectedAppointmentId = '';
  bool get selected => selectedAppointmentId == appointment.id;

  static Appointment get selectedAppointment => appointmentList.firstWhere((element) => element.id == selectedAppointmentId);

  listenAppointments() {
    Stream<List<Appointment>> stream =
        firestore.collection('appointments').snapshots().map((event) => event.docs.map((e) => Appointment.fromJson(e.data(), e.id)).toList());
    appointmentList.bindStream(stream);
  }

  Future<Result> add() async {
    return firestore
        .collection('appointments')
        .add(appointment.toJson())
        .then((value) => Result.success("Appointment added successfully"))
        .onError((error, stackTrace) => Result.error(error.toString()));
  }

  Future<Result> change() async {
    printInfo(info: appointment.id.toString());
    return firestore
        .collection('appointments')
        .doc(appointment.id)
        .update(appointment.toJson())
        .then((value) => Result.success("Appointment Updated successfully"))
        .onError((error, stackTrace) => Result.error(error.toString()));
  }

  Future<Result> delete() async {
    return firestore
        .collection('appointments')
        .doc(appointment.id)
        .delete()
        .then((value) => Result.success("Appointment Updated successfully"))
        .onError((error, stackTrace) => Result.error(error.toString()));
  }

  Stream<Appointment> get stream =>
      firestore.collection('appointments').doc(appointment.id).snapshots().map((event) => Appointment.fromJson(event.data()!, event.id));
}
