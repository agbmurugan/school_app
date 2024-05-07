import 'package:get/get.dart';
import 'package:school_app/controllers/crud_controller.dart';
import '../constants/constant.dart';
import '../models/response.dart';
import '../models/admin.dart';

class AdminController extends GetxController implements CRUD {
  AdminController(this.admin);

  final Admin admin;
  static RxList<Admin> adminList = <Admin>[].obs;

  static String selectedIcNumber = '';
  bool get selected => selectedIcNumber == admin.icNumber;

  static Admin get selectedAdmin => adminList.firstWhere((element) => element.icNumber == selectedIcNumber);

  listenAdmins() {
    Stream<List<Admin>> stream = firestore.collection('admins').snapshots().map((event) => event.docs.map((e) => Admin.fromJson(e.data())).toList());
    adminList.bindStream(stream);
  }

  @override
  Future<Result> add() async {
    return firestore
        .collection('admins')
        .doc(admin.docId)
        .set(admin.toJson())
        .then((value) => Result.success("Admin added successfully"))
        .onError((error, stackTrace) => Result.error(error.toString()));
  }

  @override
  Future<Result> change() async {
    return firestore
        .collection('admins')
        .doc(admin.docId)
        .update(admin.toJson())
        .then((value) => Result.success("Admin Updated successfully"))
        .onError((error, stackTrace) => Result.error(error.toString()));
  }

  @override
  Future<Result> delete() async {
    return firestore
        .collection('admins')
        .doc(admin.docId)
        .delete()
        .then((value) => Result.success("Admin Updated successfully"))
        .onError((error, stackTrace) => Result.error(error.toString()));
  }

  Stream<Admin> get stream => firestore.collection('admins').doc(admin.docId).snapshots().map((event) => Admin.fromJson(event.data()!));
}
