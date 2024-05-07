// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_app/controllers/queue_controller.dart';
import 'package:school_app/controllers/session_controller.dart';
import 'package:school_app/widgets/student_tile.dart';

class Carousel extends StatefulWidget {
  const Carousel({Key? key}) : super(key: key);

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  @override
  void dispose() {
    queueController.queuedStudentsList.clear();
    super.dispose();
  }

  @override
  void initState() {
    Get.put((QueueController()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
        automaticallyImplyLeading: false,
        leading: Center(
          child: IconButton(
              onPressed: () {
                session.showSideBar = true;

                session.update();
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 10,
              )),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                // List<String>? voices = await queueController.flutterTts.getVoices;
                // String? voice;
                List<DropdownMenuItem<String>> voices = [];
                String selectedVoice;
                await queueController.flutterTts.getVoices.then((values) {
                  for (var element in (values as List)) {
                    voices.add(DropdownMenuItem<String>(
                      child: Text(element['name']),
                      value: element['locale'],
                    ));
                  }
                });
                if (voices.isEmpty) {
                  return;
                } else {
                  selectedVoice = voices.first.value!;
                }
                var languages = await queueController.flutterTts.getLanguages;
                showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder: (context, setstate) {
                        return AlertDialog(
                          title: const Text("Select Accent"),
                          content: DropdownButtonFormField(
                              value: selectedVoice,
                              items: (languages as List<Object?>)
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e.toString()),
                                        value: e.toString(),
                                      ))
                                  .toList(),
                              onChanged: (v) {
                                setstate(() {
                                  selectedVoice = v as String;
                                });
                              }),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("CANCEL")),
                            TextButton(
                                onPressed: () {
                                  queueController.flutterTts.isLanguageAvailable(selectedVoice).then((value) {
                                    if (value) {
                                      queueController.flutterTts.setLanguage(selectedVoice).then((value) {
                                        Navigator.of(context).pop();
                                      });
                                      // print("Langage available");
                                    }
                                  });
                                },
                                child: const Text("OKAY")),
                          ],
                        );
                      });
                    });
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      body: GetBuilder(
        init: queueController,
        builder: (_) {
          return GridView.count(
            crossAxisCount: 4,
            childAspectRatio: 3,
            children: queueController.queuedStudentsList
                .map((e) => StudentTile(student: e.student, string: queueController.countDown[e.icNumber] ?? ''))
                .toList(),
          );
        },
      ),
    );
  }
}
