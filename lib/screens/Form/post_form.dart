import 'package:flutter/material.dart';
import 'package:school_app/constants/constant.dart';
import 'package:school_app/controllers/post_controller.dart';
import 'package:school_app/screens/Form/Widgets/desktop_post_form.dart';
import 'package:school_app/screens/Form/controllers/post_form_controller.dart';

import '../../models/post.dart';
import 'Widgets/mobile_postform.dart';

class PostForm extends StatefulWidget {
  const PostForm({Key? key, this.post}) : super(key: key);

  final Post? post;

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  @override
  void initState() {
    if (widget.post != null) {
      formController = PostFormController.fromPost(widget.post!);
    } else {
      formController = PostFormController(null);
    }
    super.initState();
  }

  void submit() {
    var controller = PostController(post: formController);
    showFutureCustomDialog(
        context: context,
        future: widget.post != null ? controller.update() : controller.add(),
        onTapOk: () {
          Navigator.of(context).pop();
        });
  }

  late PostFormController formController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Announcement'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 1050) {
          // session.showSideBar = false;
          return DesktopPostForm(
            formController: formController,
            submit: submit,
          );
        } else {
          return MobilePostForm(formController: formController, submit: submit);
        }
      }),
    );
  }
}



// class AttachmentTile extends StatelessWidget {
//   const AttachmentTile({Key? key, required this.attachment}) : super(key: key);

//   final Attachment? attachment;

//   @override
//   Widget build(BuildContext context) {
//     if (attachment == null) {
//       return ListTile(
//         title: Text("Add Attachment"),
//         leading: Icon(Icons.add),
//       );
//     }
//   }
// }
