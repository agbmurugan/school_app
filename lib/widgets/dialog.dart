import 'package:flutter/material.dart';

import '../models/response.dart';

showFutureDialog(
    {required BuildContext context,
    required Future<dynamic> future,
    required void Function() onSuccess,
    required void Function() onFailure}) {
  showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                var response = snapshot.data as Result;
                var title = response.code;
                return AlertDialog(
                  backgroundColor: Colors.red[100],
                  title: Column(
                    children: [
                      Image.asset(
                        "assets/icon/iuicon2.png",
                        fit: BoxFit.fill,
                      ),
                      Text(
                        '$title!',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  content: Text(
                    response.message,
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[800],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                          onPressed: response.code == "error" ? onFailure : onSuccess,
                          child: const Text("Continue")),
                    )
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
      });
}
