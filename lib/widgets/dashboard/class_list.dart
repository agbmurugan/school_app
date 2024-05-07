import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_app/constants/constant.dart';
import 'package:school_app/controllers/classlist_controller.dart';

// ignore: must_be_immutable
class ClassList extends StatelessWidget {
  ClassList({Key? key}) : super(key: key);

  final TextEditingValue classname = const TextEditingValue();
  final TextEditingValue sectionName = const TextEditingValue();

  final _sectionFormKey = GlobalKey<FormState>();
  final _classFormKey = GlobalKey<FormState>();

  String? classField;

  List<DropdownMenuItem<String>> getClassItems() {
    return classController.classes.keys
        .map((e) => DropdownMenuItem(
              child: Text(e),
              value: e.toString(),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Class Master"),
          centerTitle: true,
        ),
        body: GetBuilder(
            init: classController,
            builder: (_) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 8,
                      child: Form(
                        key: _classFormKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                                title: const Text("Name"),
                                subtitle: TextFormField(
                                  controller: classController.name,
                                  validator: (text) {
                                    if ((text ?? '').removeAllWhitespace.isEmpty) {
                                      return "Class Name should not be empty";
                                    }
                                    if (classController.classes.keys.contains(text!.toUpperCase().removeAllWhitespace)) {
                                      return "Duplicate Class Name ";
                                    }
                                    return null;
                                  },
                                )),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (_classFormKey.currentState!.validate()) {
                                      var future = classController.addClass();
                                      showFutureCustomDialog(
                                          context: context,
                                          future: future,
                                          onTapOk: () {
                                            classController.name.clear();
                                            classController.update();
                                            Navigator.of(context).pop();
                                          });
                                    }
                                  },
                                  child: const Text("Add")),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 8,
                      child: Form(
                        key: _sectionFormKey,
                        child: Column(
                          children: [
                            ListTile(
                                title: const Text("Name"),
                                subtitle: DropdownButtonFormField<String?>(
                                  items: getClassItems(),
                                  value: classField,
                                  onChanged: (text) {
                                    classField = text;
                                  },
                                )),
                            ListTile(
                                title: const Text("Section"),
                                subtitle: TextFormField(
                                  controller: classController.section,
                                  validator: (text) {
                                    if ((text ?? '').removeAllWhitespace.isEmpty) {
                                      return "Section is Required";
                                    }
                                    if ((classController.classes[classField] ?? []).contains((text ?? '').toUpperCase().removeAllWhitespace)) {
                                      return "Section Already Exists";
                                    }
                                    return null;
                                  },
                                )),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (_sectionFormKey.currentState!.validate()) {
                                      var future = classController.addSection(classField!, classController.section.text.removeAllWhitespace);
                                      showFutureCustomDialog(
                                          context: context,
                                          future: future,
                                          onTapOk: () {
                                            Navigator.of(context).pop();
                                          });
                                    }
                                  },
                                  child: const Text("Add")),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}


  // LayoutBuilder(builder: (context, constraints) {
                      //   return ListTile(
                      //       title: const Text("Name"),
                      //       subtitle: Autocomplete(
                      //         initialValue: classname,
                      //         optionsViewBuilder: (context, onSelected,
                      //                 Iterable<String> options) =>
                      //             Align(
                      //           alignment: Alignment.topLeft,
                      //           child: Material(
                      //             shape: const RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.vertical(
                      //                   bottom: Radius.circular(4.0)),
                      //             ),
                      //             child: SizedBox(
                      //               height: 52.0 * options.length,
                      //               width: constraints.biggest.width -
                      //                   30, // <-- Right here !
                      //               child: ListView.builder(
                      //                 padding: EdgeInsets.zero,
                      //                 itemCount: options.length,
                      //                 shrinkWrap: false,
                      //                 itemBuilder:
                      //                     (BuildContext context, int index) {
                      //                   final String option =
                      //                       options.elementAt(index);
                      //                   return ListTile(
                      //                     onTap: () => onSelected,
                      //                     title: Text(option),
                      //                   );
                      //                 },
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //         optionsBuilder: (value) {
                      //           return classController.classes.keys;
                      //         },
                      //       ));
                      // }),