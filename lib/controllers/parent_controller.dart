import 'dart:math';

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:school_app/constants/constant.dart';
import 'package:school_app/controllers/crud_controller.dart';
import 'package:school_app/models/response.dart';
import 'package:school_app/models/student.dart';

import '../models/parent.dart';

class ParentController extends GetxController implements CRUD {
  ParentController({required this.parent});
  static ParentController instance = Get.find();
  final _firebaseAuth = FirebaseAuth.instance;
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  final Parent parent;

  static RxList<Parent> parentsList = <Parent>[].obs;

  static Stream<List<Parent>> listenParents() {
    Stream<List<Parent>> stream =
        firestore.collection('parents').snapshots().map((event) => event.docs.map((e) => Parent.fromJson(e.data())).toList());
    parentsList.bindStream(stream);
    print(" $stream ===================");
    return stream;
  }

  // Function to delete the user account associated with the parent
 Future<void> deleteAccount(String email,String password) async {
  try {
    // Find the user by email
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password, // Provide a temporary password
    );

    // Get the user
    User? user = userCredential.user;

    // Check if the user is signed in
    if (user != null) {
      // Delete the user account
      await user.delete();
    }
  } catch (error) {
    // Handle error if any
    print("Error deleting user account: $error");
  }
}

  @override
  Future<Result> add() async {
    var docId = firestore.collection('parents').doc(parent.icNumber).id;
    parent.docId = docId;
    parent.isActive = true;
    return firestore
        .collection('parents')
        .doc(parent.docId)
        .set(parent.toJson())
        .then((value) => Result.success("Parent added successfully"))
        .onError((error, stackTrace) => Result.error(error.toString()));
  }

  @override
  Future<Result> change() async {
    List<Future> futures = [];
    for (var element in parent.children) {
          print("hi i am change function $element");
      futures.add(firestore.collection('students').where('icNumber', isEqualTo: element).get().then((value) {
        var student = Student.fromJson(value.docs.first.data(), value.docs.first.id);
        if (student.father?.icNumber == parent.icNumber) {
          student.father = parent;
        }
        if (student.mother?.icNumber == parent.icNumber) {
          student.mother = parent;
        }
        if (student.guardian?.icNumber == parent.icNumber) {
          student.guardian = parent;
        }
        return firestore.collection('students').doc(student.docId).set(student.toJson());
      }));
    }

    return Future.wait(futures)
        .then((value) => firestore
            .collection('parents')
            .doc(parent.icNumber)
            .set(parent.toJson())
            .then((value) => Result.success("Parent Updated successfully"))
            .onError((error, stackTrace) => Result.error(error.toString())))
        .onError((error, stackTrace) => Result.error(error.toString()));
  }

  // @override
// Future<Result> delete() async {
//   try {
//     // Delete admin data if it exists
//     var adminSnapshot = await firestore.collection('admins').doc(parent.icNumber).get();
//     if (adminSnapshot.exists) {
//       await firestore.collection('admins').doc(parent.icNumber).delete();
//     }

//     // Get the email ID of the parent
//     var parentSnapshot = await firestore.collection('parents').doc(parent.icNumber).get();
//     var email = parentSnapshot.data()?['email']; // Replace 'email' with the actual field name
//     var password = parentSnapshot.data()?['password'];
//     var isActive = parentSnapshot.data()?['isActive'];

//     // Delete the associated user account
    

//     // Delete the parent data from Firestore
//     var fireList = firestore
//         .collection('parents')
//         .doc(parent.icNumber)
//         .delete()
//         .then((value) => Result.success("Parent Updated successfully"))
//         .onError((error, stackTrace) => Result.error(error.toString()));
//         print("$fireList list of parent");
// if (email != null) {
//       await deleteAccount(email,password);
//     }
//     // Return success message
//     return fireList;
//   } catch (error) {
//     // Return error message
//     return Result.error(error.toString());
//   }
// }
@override
Future<Result> delete() async {
  try {
    // Fetch the document of the parent you want to deactivate
    var parentSnapshot = await firestore.collection('parents').doc(parent.icNumber).get();

    // Check if the document exists
    if (parentSnapshot.exists) {
      // Update the isActive field to false instead of deleting the parent
      await firestore.collection('parents').doc(parent.icNumber).update({
        'isActive': false
      });
      return Result.success("Parent deactivated successfully");
    } else {
      return Result.error("Parent not found");
    }
  } catch (error) {
    // Return error message if something goes wrong
    return Result.error("Failed to deactivate parent: ${error.toString()}");
  }
}


  Stream<Parent> get stream => firestore.collection('parents').doc(parent.icNumber).snapshots().map((event) => Parent.fromJson(event.data()!));
}