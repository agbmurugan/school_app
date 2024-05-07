import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_app/constants/constant.dart';
import 'package:school_app/models/post.dart';
import 'package:school_app/models/response.dart';
import 'package:school_app/models/session.dart';
import 'package:school_app/models/student.dart';
import 'package:school_app/models/teacher.dart';
import 'package:school_app/screens/Form/controllers/post_form_controller.dart';

class PostController {
  final PostFormController post;

  PostController({required this.post});

  static CollectionReference<Map<String, dynamic>> get allTeacherPosts => firestore.collection('teachers').doc('general').collection('posts');
  static CollectionReference<Map<String, dynamic>> get allStudentPosts => firestore.collection('students').doc('general').collection('posts');
  static CollectionReference<Map<String, dynamic>> get allAdminPosts => firestore.collection('admins').doc('general').collection('posts');
  static getTeacherPost(Teacher teacher) => firestore.collection('teachers').doc(teacher.icNumber).collection('posts');
  static getStudentPost(Student teacher) => firestore.collection('teachers').doc(teacher.icNumber).collection('posts');
  static Query<Map<String, dynamic>> get posts => firestore.collectionGroup('posts');

  Future<List<Attachment>> uploadDocuments() {
    List<Attachment> returns = [];
    returns.addAll(post.attachments);
    List<Future<Attachment>> tempFutures = [];
    for (var element in post.platformFiles) {
      tempFutures.add(uploadFile(element.bytes!, element.name));
    }
    return Future.wait(tempFutures).then((value) {
      returns.addAll(value);
      return returns;
    });
  }

  removeDocuments() {
    for (var attachment in post.deletedAtachments) {
      storage.refFromURL(attachment.url).delete();
    }
    if (post.fileData != null) {
      post.contentImage = null;
    }
  }

  Future<Post> convertToPost() async {
    removeDocuments();
    List<Future> futures = [];
    if (post.platformFiles.isNotEmpty) {
      futures.add(uploadDocuments().then((value) => post.attachments = value));
    }
    if (post.fileData != null) {
      futures.add(
        uploadFile(post.fileData!, post.title.text).then(
          (value) {
            post.contentImage = value.url;
          },
        ),
      );
    }
    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }
    return post.object;
  }

  Future<Attachment> uploadFile(Uint8List file, String name) async {
    var ref = storage.ref("posts").child(name);
    var url = await ref.putData(file).then((p0) => p0.ref.getDownloadURL());
    return Attachment(name: name, url: url, attachmentLocation: AttachmentLocation.cloud);
  }

  Future<Result> add() {
    post.postBy = MySession().bio;
    return convertToPost().then((value) {
      return firestore.collection('posts').add(value.toJson()).then((value) => Result.success('Post Added Successfully'));
    }).catchError((error) {
      return Result.error(error.toString());
    });
  }

  Future<Result> update() {
    post.postBy = MySession().bio;
    return convertToPost().then((value) {
      return firestore.collection('posts').doc(post.docId).update(value.toJson()).then((value) => Result.success('Post Updated Successfully'));
    }).catchError((error) {
      return Result.error(error.toString());
    });
  }
}
