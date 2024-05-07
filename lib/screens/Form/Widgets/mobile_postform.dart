import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_app/screens/Form/controllers/bio_form_controller.dart';
import 'package:school_app/screens/Form/controllers/post_form_controller.dart';
import 'package:school_app/widgets/custom_drop_down.dart';
import 'package:school_app/widgets/custom_text_field.dart';

import '../../../constants/get_constants.dart';
import '../../../models/biodata.dart';
import '../../../models/post.dart';

class MobilePostForm extends StatefulWidget {
  const MobilePostForm({Key? key, required this.formController, required this.submit}) : super(key: key);

  final PostFormController formController;
  final void Function() submit;

  @override
  State<MobilePostForm> createState() => _MobilePostFormState();
}

class _MobilePostFormState extends State<MobilePostForm> {
  PostFormController get formController => widget.formController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 200,
            child: Center(
              child: Icon(
                FontAwesomeIcons.radio,
                size: 60,
              ),
            ),
          ),
          CustomTextBox(hintText: 'Title', controller: formController.title),
          CustomTextBox(
            hintText: 'Message',
            controller: formController.content,
            maxLines: 5,
          ),
          SizedBox(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: formController.contentDisplay == Provide.logo
                  ? GestureDetector(
                      onTap: () {
                        formController.imagePicker().then((value) {
                          setState(() {});
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Card(color: Colors.grey.shade300, child: const Center(child: Icon(Icons.add_a_photo))),
                      ),
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
          CustomDropDown<Audience>(
              labelText: 'Audience',
              onChanged: (audience) {
                setState(() {
                  formController.audience = audience ?? formController.audience;
                });
              },
              items: Audience.values.map((e) => DropdownMenuItem(value: e, child: Text(e.toString().split('.').last.toUpperCase()))).toList(),
              selectedValue: formController.audience),
          formController.audience == Audience.individual
              ? ListTile(
                  title: const Text(
                    'Receipient',
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Autocomplete<Bio>(
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
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(8),
                                fillColor: Colors.white,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: Colors.blue, width: 1)),
                                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
                                errorBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(4.0)), borderSide: BorderSide(color: Colors.red))),
                          );
                        },
                      );
                    }),
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Attachments',
                  style: getText(context).bodyText1,
                )),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 400),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  shrinkWrap: true,
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
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: widget.submit,
              child: const Text("Submit"),
            ),
          ),
        ],
      ),
    );
  }
}
