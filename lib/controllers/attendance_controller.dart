// ignore_for_file: constant_identifier_names, avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_app/constants/constant.dart';

// import '../models/biodata.dart';

const USERNAME = 'admin';
const PASSWORD = 'Admin1040@';
const HOST = 'http://f0270f046de7.sn.mynetname.net:81';

class AttendanceController extends GetxController {
  static AttendanceController instance = Get.find();
  @override
  void onInit() {
    // getAuth();
    Timer.periodic(const Duration(minutes: 15), (timer) {
      loadToken();
    });
    super.onInit();
  }

  static String token = '';

  // static sendRequest() {}

  static Future<void> loadToken() {
    var calable = functions.httpsCallable('loadToken', options: HttpsCallableOptions(timeout: const Duration(seconds: 5)));
    return calable.call().then((value) {
      token = value.data;
    });
  }

  // static Future<void> loadToken() async {
  //   var headers = {'Content-Type': 'application/json'};
  //   var request = http.Request('POST', Uri.parse('http://f0270f046de7.sn.mynetname.net:81/jwt-api-token-auth/'));
  //   request.body = json.encode({"username": "admin", "password": "Admin1040@"});
  //   request.headers.addAll(headers);

  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {
  //     var body = await response.stream.bytesToString();
  //     print(await response.stream.bytesToString());
  //     token = jsonDecode(body)["token"];
  //   } else {
  //     print(response.reasonPhrase);
  //   }

  //   return;
  // }

  // static const posistionMap = {
  //   EntityType.student: 16,
  //   EntityType.teacher: 17,
  // };

  // static const departmentMap = {
  //   EntityType.student: 265,
  //   EntityType.teacher: 266,
  // };

  // createEmployee(Bio bio) {
  //   var url = '$HOST/personnel/api/employees/';
  //   var uri = Uri.parse(url);
  //   var body = {
  //     "emp_code": bio.icNumber,
  //     "department": 1,
  //     "area": [20, 21],
  //     "position": posistionMap[bio.entityType],
  //   };
  //   uri.post(body: body).then((value) => print(jsonDecode(value.body)));
  // }

  // loadTodayAttendance() {}

  // getTransactionReport(DateTime fromDate, DateTime toDate, EntityType entityType) {
  //   // var url = '$HOST/att/api/transactionReport/';
  //   var params = {
  //     'start_date': fromDate.toString().substring(0, 10),
  //     'end_date': toDate.toString().substring(0, 19),
  //     'departments': [265, 266],
  //   };
  //   var uri = Uri.https(HOST, '/att/api/transactionReport/', params);

  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': AttendanceController.token,
  //   };
  //   http.get(uri, headers: headers).then((value) => print(jsonDecode(value.body)));
  // }
}

// extension Raptor on Uri {
//   Map<String, String> get headers => {
//         'Content-Type': 'application/json',
//         'Authorization': AttendanceController.token,
//       };
//   Future<http.Response> post({Map<String, dynamic>? body, Map<String, String>? additionalHeaders}) {
//     if (additionalHeaders != null) {
//       headers.addAll(additionalHeaders);
//     }
//     return http.post(this, headers: headers, body: jsonEncode(body));
//   }
// }

AttendanceController attendanceController = AttendanceController.instance;
