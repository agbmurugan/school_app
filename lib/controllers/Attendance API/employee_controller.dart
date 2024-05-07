import 'package:cloud_functions/cloud_functions.dart';
import 'package:school_app/constants/constant.dart';
import 'package:school_app/controllers/attendance_controller.dart';
import 'package:school_app/models/Attendance/employee.dart';

class EmployeeController {
  static Future<Employee> addEmployee(Employee employee) async {
    var callable = functions.httpsCallable('addEmployee', options: HttpsCallableOptions(timeout: const Duration(seconds: 5)));
    var data = employee.toJson();
    data.addAll({'token': AttendanceController.token});
    return callable.call(data).then((response) {
      var value = response.data;
      var employee = Employee.fromJson(value);
      return employee;
    });
  }

  static Future<Employee> updateEmployee(Employee employee) async {
    var callable = functions.httpsCallable('updateEmployee', options: HttpsCallableOptions(timeout: const Duration(seconds: 5)));
    var data = employee.toJson();
    data.addAll({'token': AttendanceController.token});
    return callable.call(data).then((response) {
      var value = response.data;
      var employee = Employee.fromJson(value);
      return employee;
    });
  }

  static Future<Employee> deleteEmployee(Employee employee) async {
    var callable = functions.httpsCallable('deleteEmployee', options: HttpsCallableOptions(timeout: const Duration(seconds: 5)));
    var data = employee.toJson();
    data.addAll({'token': AttendanceController.token});
    return callable.call(data).then((response) {
      var value = response.data;
      var employee = Employee.fromJson(value);
      return employee;
    });
  }
}
