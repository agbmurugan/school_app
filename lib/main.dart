import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_app/controllers/Attendance%20API/trnasaction_controller.dart';
import 'package:school_app/controllers/attendance_controller.dart';
import 'package:school_app/controllers/Attendance%20API/department_controller.dart';
import 'package:school_app/controllers/session_controller.dart';
import 'package:school_app/auth_router.dart';
import 'package:school_app/models/session.dart';

import 'controllers/auth_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  runApp(const SplashScreen());
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  Future<void> getFutures() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((value) {
      // FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
      // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      return Future.wait([AttendanceController.loadToken(), auth.reloadClaims()]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getFutures(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
          try {
            Get.put(AuthController());
            Get.put(SessionController(MySession()));
            Get.put(TransactionController());
            Get.put(DepartmentController());
          } catch (e) {}
          return const AuthRouter();
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
