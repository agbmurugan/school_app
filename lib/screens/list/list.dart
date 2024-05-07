import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_app/controllers/admin_controller.dart';
import 'package:school_app/controllers/parent_controller.dart';
import 'package:school_app/controllers/student_controller.dart';
import 'package:school_app/controllers/teacher_controller.dart';
import 'package:school_app/models/biodata.dart';
import 'package:school_app/screens/Form/parent_form.dart';
import 'package:school_app/screens/Form/student_form.dart';
import 'package:school_app/screens/Form/teacher_form.dart';
import 'package:school_app/screens/list/source/bio_source.dart';

import '../../constants/get_constants.dart';
import '../../controllers/session_controller.dart';
import '../Form/controllers/student_form_controller.dart';

class EntityList extends StatefulWidget {
  const EntityList({Key? key, required this.entityType}) : super(key: key);
  final EntityType entityType;

  static const routeName = '/passArguments';
  @override
  State<EntityList> createState() => _EntityListState();
}

class _EntityListState extends State<EntityList> {
  StudentFormController get controller => session.formcontroller;
  String? className;
  String? search;
  String? section;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(isMobile(context) ? 2 : 8),
        child: StreamBuilder<List<Bio>>(
            initialData: getList(),
            stream: getStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
                var list = snapshot.data;
                if ((search ?? '').isNotEmpty) {
                  list = list!.where((element) => element.name.startsWith(search!)).toList();
                }

                var source = BioSource(list!, context);
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: isMobile(context) ? getWidth(context) * 2 : getWidth(context) * 0.80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(widget.entityType.name.toString().toUpperCase()),
                              Expanded(child: Container()),
                              SizedBox(
                                  height: getHeight(context) * 0.08,
                                  width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
                                  child: Center(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: getColor(context).secondary,
                                        ),
                                        border: const OutlineInputBorder(),
                                      ),
                                    ),
                                  )),
                              // SizedBox(
                              //     height: getHeight(context) * 0.053,
                              //     width: getWidth(context) * 0.10,
                              //     child: DropdownButtonFormField<String?>(
                              //       value: className,
                              //       decoration: const InputDecoration(
                              //         labelText: 'Class',
                              //         border: OutlineInputBorder(),
                              //       ),
                              //       items: controller.classItems,
                              //       onChanged: (text) {
                              //         setState(() {
                              //           className = text;
                              //         });
                              //       },
                              //     )),
                              // SizedBox(
                              //   height: getHeight(context) * 0.053,
                              //   width: getWidth(context) * 0.10,
                              //   child: DropdownButtonFormField<String?>(
                              //     value: section,
                              //     decoration: const InputDecoration(
                              //       labelText: 'Section',
                              //       border: OutlineInputBorder(),
                              //     ),
                              //     items: controller.sectionItems,
                              //     onChanged: (text) {
                              //       setState(() {
                              //         section = text;
                              //       });
                              //     },
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      switch (widget.entityType) {
                                        case EntityType.student:
                                          Get.toNamed(StudentForm.routeName, arguments: null);
                                          break;
                                        case EntityType.teacher:
                                          Get.to(() => const TeacherForm());
                                          break;
                                        case EntityType.parent:
                                          Get.to(() => const ParentForm());
                                          break;
                                        case EntityType.admin:
                                          // ignore: todo
                                          // TODO: Handle this case.
                                          break;
                                      }
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text("Add"),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {});
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text("Refresh"),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: getWidth(context) * 0.90,
                          maxWidth: 1980,
                        ),
                        child: PaginatedDataTable(
                          dragStartBehavior: DragStartBehavior.start,
                          columns: BioSource.getCoumns(widget.entityType),
                          source: source,
                          rowsPerPage: (getHeight(context) ~/ kMinInteractiveDimension) - 5,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (snapshot.hasError) {
                return const Text("Error occured");
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }

  List<Bio> getList() {
    switch (widget.entityType) {
      case EntityType.student:
        return StudentController.studentList.toList();
      case EntityType.teacher:
        return TeacherController.teacherList.toList();
      case EntityType.parent:
        return ParentController.parentsList.toList();
      case EntityType.admin:
        return AdminController.adminList.toList();
    }
  }

  getStream() {
    switch (widget.entityType) {
      case EntityType.student:
        return StudentController.listenStudents();
      case EntityType.teacher:
        return TeacherController.listenTeachers();
      case EntityType.parent:
        return ParentController.listenParents();
      case EntityType.admin:
        return AdminController.adminList.stream;
    }
  }
}
