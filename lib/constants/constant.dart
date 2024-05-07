import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import '../models/response.dart';
import 'package:cloud_functions/cloud_functions.dart';

final FirebaseFunctions functions = FirebaseFunctions.instance;
final FirebaseStorage storage = FirebaseStorage.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference<Map<String, dynamic>> students = firestore.collection('students');
final CollectionReference<Map<String, dynamic>> classes = firestore.collection('classes');
DatabaseReference ref = FirebaseDatabase.instance.ref();

List<String> makeSearchstring(String string) {
  List<String> list = [];
  for (int i = 1; i < string.length; i++) {
    list.add(string.substring(0, i).toLowerCase());
  }
  list.add(string.toLowerCase());
  return list;
}

String getRandString(int len) {
  var random = Random.secure();
  var values = List<int>.generate(len, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

Future<String> uploadImage(Uint8List file, String name) async {
  var ref = storage.ref(name).child(name + DateTime.now().microsecondsSinceEpoch.toString());
  var url = ref.putData(file).then((p0) => p0.ref.getDownloadURL());
  return url;
}

showFutureCustomDialog({required BuildContext context, required Future<Result> future, required void Function()? onTapOk}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                var response = snapshot.data as Result;
                if (response.code == "success") {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
                return AlertDialog(
                  title: Text(response.code),
                  content: Text(response.message),
                  actions: [
                    ElevatedButton(
                        onPressed: response.code == "Error"
                            ? () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              }
                            : onTapOk,
                        child: const Text("Okay"))
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
      });
}

class CustomListtile extends StatelessWidget {
  const CustomListtile({Key? key, this.subtitle, this.title, required this.data}) : super(key: key);
  final Widget? subtitle;
  final Widget? title;
  final String data;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        data,
        style: const TextStyle(color: Colors.red),
      ),
      subtitle: subtitle,
    );
  }
}

const Color primarycolor = Color(0xFFc2185B);
const Color bgcolor = Colors.white;
const defaultpadding = 20.0;
const textboxgap = 10.0;
