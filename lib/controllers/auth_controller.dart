import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:school_app/models/response.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  onInit() {
    reloadClaims();
    super.onInit();
  }

  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  Stream<bool> checkUserVerified() async* {
    bool verified = false;
    while (!verified) {
      await Future.delayed(const Duration(seconds: 5));
      if (currentUser != null) {
        await currentUser!.reload();
        verified = currentUser!.emailVerified;

        if (verified) yield true;
      }
    }
  }

  bool? isAdmin;
  bool? isTeacher;

  User? get currentUser => _firebaseAuth.currentUser;

  String? get uid => currentUser?.uid;

  Future<bool> reloadClaims() async {
    var returns = false;
    try {
      IdTokenResult? result = await currentUser?.getIdTokenResult();
      if (result != null) {
        isAdmin = result.claims?['admin'] ?? false;
        isTeacher = result.claims?['teacher'] ?? false;
        returns = isAdmin! || isTeacher!;
        update();
      }
    } catch (e) {
      returns = false;
    }
    return returns;
  }

  String handleFirebaseAuthError(String e) {
    if (e.contains("ERROR_WEAK_PASSWORD")) {
      return "Password is too weak";
    } else if (e.contains("invalid-email")) {
      return "Invalid Email";
    } else if (e.contains("ERROR_EMAIL_ALREADY_IN_USE") || e.contains('email-already-in-use')) {
      return "The email address is already in use by another account.";
    } else if (e.contains("ERROR_NETWORK_REQUEST_FAILED")) {
      return "Network error occured!";
    } else if (e.contains("ERROR_USER_NOT_FOUND") || e.contains('firebase_auth/user-not-found')) {
      return "Invalid credentials.";
    } else if (e.contains("ERROR_WRONG_PASSWORD") || e.contains('wrong-password')) {
      return "Invalid credentials.";
    } else if (e.contains('firebase_auth/requires-recent-login')) {
      return 'This operation is sensitive and requires recent authentication.'
          ' Log in again before retrying this request.';
    } else {
      return e;
    }
  }

  Future<Result> signInWithEmailAndPassword(String email, String password) async {
    return _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((userCredential) {
          userCredential.user?.getIdTokenResult().then((result) {
            isAdmin = result.claims?['admin'] ?? false;
            isTeacher = result.claims?['teacher'] ?? false;
            update();
          });
        })
        .then((value) => Result.success("User Successfully logged in"))
        .onError((error, stackTrace) {
          if (error is FirebaseAuthException) {
            return Result(code: error.code, message: handleFirebaseAuthError(error.code));
          } else {
            return Result.error(error.toString());
          }
        });
  }

  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<String> resetPassword({required String email}) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email).then((value) => "Success").catchError((error) {
      return error.code.toString();
    });
  }

  Future<void> signOut() async {
    isAdmin = null;
    isTeacher = null;
    await _firebaseAuth.signOut();
  }
  
}

AuthController auth = AuthController.instance;
