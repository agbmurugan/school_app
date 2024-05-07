import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_app/constants/get_constants.dart';
import 'package:school_app/models/biodata.dart';
import 'package:school_app/models/post.dart';
import 'package:school_app/screens/Form/controllers/post_form_controller.dart';
import '../controllers/bio_form_controller.dart';

class DesktopPostForm extends StatefulWidget {
  const DesktopPostForm({Key? key, required this.formController, required this.submit}) : super(key: key);

  final PostFormController formController;
  final void Function() submit;

  @override
  State<DesktopPostForm> createState() => _DesktopPostFormState();
}

class _DesktopPostFormState extends State<DesktopPostForm> {
  PostFormController get formController => widget.formController;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Container(
            width: 456,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Align(
                      child: Text(
                        "CONTENT IMAGE",
                        style: getText(context).bodyText1,
                      ),
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: formController.contentDisplay == Provide.logo
                          ? GestureDetector(
                              onTap: () {
                                formController.imagePicker().then((value) {
                                  setState(() {});
                                });
                              },
                              child: Card(color: Colors.grey.shade300, child: const Center(child: Icon(Icons.add_a_photo))),
                            )
                          : Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Card(
                                    child: Image(
                                      image: formController.getImageProvider(),
                                      alignment: Alignment.center,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                        onPressed: () {
                                          formController.removeImage();
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.close))),
                              ],
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Align(
                      child: Text(
                        "ATTACHMENTS",
                        style: getText(context).bodyText1,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: formController.tempAttachments.length,
                        itemBuilder: (item, index) {
                          Attachment? attachment = formController.tempAttachments[index];
                          if (attachment != null) {
                            return ListTile(
                              leading: attachment.attachmentLocation == AttachmentLocation.cloud
                                  ? const Icon(FontAwesomeIcons.file)
                                  : const Icon(FontAwesomeIcons.fileArrowUp),
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(attachment.name),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.remove_circle),
                                onPressed: () {
                                  setState(() {
                                    formController.removeAttachement(attachment);
                                  });
                                },
                              ),
                            );
                          }
                          return ListTile(
                            leading: const Icon(FontAwesomeIcons.file),
                            title: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Add Attachment"),
                            ),
                            trailing: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.note_add,
                                size: 24,
                              ),
                            ),
                            onTap: () {
                              formController.filePicker().then((value) => setState(() {}));
                            },
                          );
                        }),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: Container(
              color: Colors.grey.shade100,
              width: 2,
            ),
          ),
          Expanded(
            flex: 4,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Text(
                      "ANNOUNCEMENT",
                      style: getText(context).headline2,
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth / 2,
                    child: ListTile(
                      title: const Text("TITLE"),
                      subtitle: TextFormField(
                        controller: formController.title,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: ListTile(
                      title: const Text("MESSAGE"),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: TextFormField(
                          controller: formController.content,
                          maxLines: 9,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade200,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: SizedBox(
                      width: constraints.maxWidth / 2,
                      child: ListTile(
                        title: const Text("AUDIENCE"),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: DropdownButtonFormField<Audience>(
                            value: formController.audience,
                            items: Audience.values
                                .map((e) => DropdownMenuItem(value: e, child: Text(e.toString().split('.').last.toUpperCase())))
                                .toList(),
                            onChanged: (audience) {
                              setState(() {
                                formController.audience = audience ?? formController.audience;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: SizedBox(
                      width: constraints.maxWidth / 2,
                      child: formController.audience == Audience.individual
                          ? ListTile(
                              title: const Text(
                                'RECEPIENT',
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: LayoutBuilder(builder: (context, constraints) {
                                  return Autocomplete<Bio>(
                                    initialValue: TextEditingValue(text: formController.sentTo?.name.toUpperCase() ?? ''),
                                    optionsBuilder: (textEditingValue) async {
                                      return Bio.findPeople(textEditingValue.text);
                                    },
                                    optionsViewBuilder: (context, onSelected, options) {
                                      return Align(
                                        alignment: Alignment.topLeft,
                                        child: Material(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 8),
                                            child: ConstrainedBox(
                                              constraints: constraints.copyWith(maxHeight: 600),
                                              child: Card(
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: options.length,
                                                    itemBuilder: (context, index) {
                                                      return Card(
                                                        child: ListTile(
                                                          leading: Image.network(
                                                            Bio.getUrl(options.elementAt(index).entityType),
                                                            height: getHeight(context) * 0.03,
                                                          ),
                                                          title: Text(options.elementAt(index).name),
                                                          subtitle: Text(options.elementAt(index).icNumber),
                                                          onTap: () {
                                                            onSelected(options.elementAt(index));
                                                          },
                                                        ),
                                                      );
                                                    }),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    onSelected: (Bio bio) {
                                      setState(() {
                                        formController.sentTo = bio;
                                      });
                                    },
                                    displayStringForOption: (bio) => bio.name,
                                    fieldViewBuilder: (context, controller, focusNode, builder) {
                                      return TextFormField(
                                        focusNode: focusNode,
                                        controller: controller,
                                        onChanged: (text) {
                                          formController.sentTo = null;
                                        },
                                      );
                                    },
                                  );
                                }),
                              ),
                            )
                          : Container(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: ElevatedButton(onPressed: widget.submit, child: const Text("SUBMIT")),
                  )
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
