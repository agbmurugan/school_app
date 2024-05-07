// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker_web/image_picker_web.dart';

import '../../../constants/constant.dart';
import '../../../models/biodata.dart';
import '../../../models/post.dart';
import 'bio_form_controller.dart';

class PostFormController {
  final String? docId;
  Audience audience = Audience.all;
  Bio? sentTo;
  Bio? postBy;
  final TextEditingController title = TextEditingController();
  final TextEditingController content = TextEditingController();
  List<Attachment> attachments = [];
  String? contentImage;
  DateTime date = DateTime.now();
  PostFormController(this.docId);

  List<Attachment> deletedAtachments = [];
  String? deletedContentImage;

  Query<Map<String, dynamic>> get posts => firestore.collectionGroup('posts');

  Uint8List? fileData;
  List<PlatformFile> platformFiles = [];
  Provide show = Provide.logo;
  ImageProvider getImageProvider() {
    if (fileData != null) {
      return MemoryImage(fileData!);
    } else if (contentImage != null) {
      return NetworkImage(contentImage!);
    } else {
      return const AssetImage('assets/logo.png');
    }
  }

  List<Attachment?> get tempAttachments {
    List<Attachment?> returns = [];
    returns.addAll(platformFiles.map((e) => Attachment(name: e.name, url: '', attachmentLocation: AttachmentLocation.local)).toList());
    returns.addAll(attachments);
    returns.add(null);
    return returns;
  }

  Provide get contentDisplay {
    var result = (fileData != null)
        ? Provide.memory
        : (contentImage != null)
            ? Provide.network
            : Provide.logo;
    // print(result);
    return result;
  }

  Future<void> imagePicker() async {
    var mediaInfo = await ImagePickerWeb.getImageInfo;
    if (mediaInfo!.data != null && mediaInfo.fileName != null) {
      fileData = mediaInfo.data;
      show = Provide.memory;
    }
    return;
  }

  Future<void> filePicker() async {
    FilePickerResult? temp = await FilePicker.platform.pickFiles(allowMultiple: true);
    platformFiles.addAll((temp?.files) ?? []);
    return;
  }

  removeImage() {
    fileData = null;
    deletedContentImage = contentImage;
    contentImage = null;
  }

  removeAttachement(Attachment attachment) {
    if (attachment.attachmentLocation == AttachmentLocation.local) {
      platformFiles.removeWhere((element) => element.name == attachment.name);
    } else {
      attachments.remove(attachment);
      deletedAtachments.add(attachment);
    }
  }

  factory PostFormController.fromPost(Post post) {
    var controller = PostFormController(post.docId);
    controller.attachments = post.attachments;
    controller.audience = post.audience;
    controller.content.text = post.content;
    controller.postBy = post.postBy;
    controller.sentTo = post.sentTo;
    controller.title.text = post.title;
    controller.contentImage = post.contentImage;
    controller.date = post.date;
    if (kDebugMode) {
      // print(controller.attachments.map((e) => e.attachmentLocation).toList());
    }
    return controller;
  }

  Post get object => Post(
        audience: audience,
        content: content.text,
        title: title.text,
        attachments: attachments,
        date: date,
        contentImage: contentImage,
        docId: docId,
        postBy: postBy,
        sentTo: sentTo,
      );
}
