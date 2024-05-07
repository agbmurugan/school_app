// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBcKhVgUbtqPigCzDAqzCY2D3v5wyY2LhI',
    appId: '1:485646374634:web:4dfac95b2a4fa12fbae993',
    messagingSenderId: '485646374634',
    projectId: 'school-app-aed59',
    authDomain: 'school-app-aed59.firebaseapp.com',
    databaseURL: 'https://school-app-aed59-default-rtdb.firebaseio.com',
    storageBucket: 'school-app-aed59.appspot.com',
    measurementId: 'G-693TE0P5Z7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAG8ZXmx3Nghu6ki48jmrGtby9Ip5gNmrM',
    appId: '1:485646374634:android:cc4f5e53fcb30ac3bae993',
    messagingSenderId: '485646374634',
    projectId: 'school-app-aed59',
    databaseURL: 'https://school-app-aed59-default-rtdb.firebaseio.com',
    storageBucket: 'school-app-aed59.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDwyiMCnESLdQZx4uk9YxZxhWh4P6clxxo',
    appId: '1:485646374634:ios:c85c5ab18636cb76bae993',
    messagingSenderId: '485646374634',
    projectId: 'school-app-aed59',
    databaseURL: 'https://school-app-aed59-default-rtdb.firebaseio.com',
    storageBucket: 'school-app-aed59.appspot.com',
    iosClientId: '485646374634-k0cpq10hojua747ug00ev60gh9tlah8k.apps.googleusercontent.com',
    iosBundleId: 'com.example.schoolapp',
  );
}
