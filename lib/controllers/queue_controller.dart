// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:collection';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:school_app/controllers/session_controller.dart';
import 'package:school_app/models/queue.dart';

class QueueController extends GetxController {
  static QueueController instance = Get.find();
  List<StudentQueue> queuedStudentsList = [];

  final Queue<StudentQueue> ttsQueue = Queue<StudentQueue>();
  int pivot = 0;
  Timer? timer;

  static int tileCount = 15;

  @override
  void onInit() {
    listenQueue = queue.orderBy("queuedTime").limit(tileCount).snapshots().listen((event) {
      for (var e in event.docChanges) {
        // if new document
        if (e.oldIndex == -1) {
          var student = StudentQueue.fromJson(e.doc.data()!);

          ttsQueue.addLast(student);
          countDown[student.icNumber] = "00:00";
          student.queuedTime = DateTime.now();
          queuedStudentsList.add(student);
          pivot < (queuedStudentsList.length - 1) ? pivot++ : pivot;

          HttpsCallable callable = FirebaseFunctions.instanceFor(region: 'asia-southeast1').httpsCallable('deQueue');
          callable
              .call(<String, dynamic>{
                'documentId': student.icNumber,
              })
              .then((value) => print(value.toString()))
              .catchError((err) {
                if (err is FirebaseFunctionsException) {
                  print(err.stackTrace);
                } else {
                  print('object');
                }
              });
          // student.timer = Timer(const Duration(seconds: 60), () {
          //   e.doc.reference.delete();
          // });
        }
        if (e.newIndex == -1) {
          var student = StudentQueue.fromJson(e.doc.data()!);
          queuedStudentsList.removeWhere((element) => element.icNumber == student.icNumber);
          pivot != 0 ? pivot-- : pivot;
        }
      }
      update();
    });
    timer = startSpeaking();
    getVoices();
    super.onInit();
  }

  @override
  void onClose() {
    if (timer != null) {
      timer!.cancel();
    }

    super.onClose();
  }

  // TextToSpeech tts = TextToSpeech();
  FlutterTts flutterTts = FlutterTts();

  getVoices() async {
    var voices = await flutterTts.getVoices;
    // print(voices);
  }

  selectVoice(Map<String, String> voice) async {
    flutterTts.setVoice(voice);
  }

  Timer startSpeaking() {
    return Timer.periodic(const Duration(seconds: 3), (timer) {
      if (queuedStudentsList.isNotEmpty) {
        pivot = timer.tick % queuedStudentsList.length;
        // tts.speak(queuedStudentsList[pivot].name);
        try {
          flutterTts.speak(queuedStudentsList[pivot].name);
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }
    });
  }

  Map<String, String> countDown = {};

  late StreamSubscription listenQueue;
}

QueueController queueController = QueueController.instance;
