import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_app/controllers/session_controller.dart';
import 'package:school_app/models/queue.dart';

class QueueList extends StatelessWidget {
  const QueueList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Queue"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: const Text("Exoprt is under development"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Okay"))
                          ],
                        );
                      });
                },
                icon: const Icon(
                  CupertinoIcons.cloud_download,
                  color: Colors.white,
                ))
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: queue.orderBy('queuedTime', descending: true).snapshots(),
          // initialData: initialData,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
              var students = snapshot.data!.docs.map((e) => StudentQueue.fromJson(e.data())).toList();
              return ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(students[index].icNumber),
                      subtitle: Text("Last Queue Time : ${students[index].queuedTime}"),
                    );
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
