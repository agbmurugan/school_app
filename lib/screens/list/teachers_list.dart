// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:school_app/models/Attendance/department.dart';
// import 'package:school_app/models/biodata.dart';
// import 'package:school_app/models/teacher.dart';
// import 'package:school_app/screens/Form/teacher_form.dart';
// import 'package:school_app/screens/list/source/bio_source.dart';

// import '../../constants/constant.dart';
// import '../../constants/get_constants.dart';
// import '../../controllers/session_controller.dart';
// import '../Form/controllers/student_form_controller.dart';

// class TeacherList extends StatefulWidget {
//   const TeacherList({Key? key}) : super(key: key);

//   static const routeName = '/passArguments';
//   @override
//   State<TeacherList> createState() => _TeacherListState();
// }

// class _TeacherListState extends State<TeacherList> {
//   StudentFormController get controller => session.formcontroller;
//   Department? className;
//   String? search;
//   Department? section;

//   Stream<List<Teacher>> getStream() {
//     Query<Map<String, dynamic>> query = firestore.collection('teachers');
//     if (search != null) {
//       query = query.where('search', arrayContains: search);
//     }
//     if (className != null) {
//       query = query.where('className', isEqualTo: className);
//     }
//     if (section != null) {
//       query = query.where('section', isEqualTo: section);
//     }

//     return query.snapshots().map((event) => event.docs.map((e) {
//           return Teacher.fromJson(e.data());
//         }).toList());
//   }

//   void Function(void Function())? setStreamBuilderState;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.all(isMobile(context) ? 2 : 8),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: SizedBox(
//                   width: isMobile(context)
//                       ? getWidth(context) * 2
//                       : getWidth(context) * 0.80,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       const Text("TEACHERS LIST"),
//                       Expanded(child: Container()),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8),
//                         child: SizedBox(
//                             height: getHeight(context) * 0.08,
//                             width: isMobile(context)
//                                 ? getWidth(context) * 0.40
//                                 : getWidth(context) * 0.20,
//                             child: Center(
//                               child: TextFormField(
//                                 onChanged: ((value) => search = value),
//                                 decoration: InputDecoration(
//                                   prefixIcon: Icon(
//                                     Icons.search,
//                                     color: getColor(context).secondary,
//                                   ),
//                                   border: const OutlineInputBorder(),
//                                 ),
//                               ),
//                             )),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8),
//                         child: SizedBox(
//                             height: getHeight(context) * 0.053,
//                             width: isMobile(context)
//                                 ? getWidth(context) * 0.40
//                                 : getWidth(context) * 0.20,
//                             child: DropdownButtonFormField<Department?>(
//                               value: className,
//                               decoration: const InputDecoration(
//                                 labelText: 'Class',
//                                 border: OutlineInputBorder(),
//                               ),
//                               items: controller.classItems,
//                               onChanged: (text) {
//                                 setState(() {
//                                   className = text;
//                                   section = null;
//                                 });
//                               },
//                             )),
//                       ),
//                       SizedBox(
//                         height: getHeight(context) * 0.053,
//                         width: isMobile(context)
//                             ? getWidth(context) * 0.40
//                             : getWidth(context) * 0.20,
//                         child: DropdownButtonFormField<Department?>(
//                           value: section,
//                           decoration: const InputDecoration(
//                             labelText: 'Section',
//                             border: OutlineInputBorder(),
//                           ),
//                           items: controller.sectionItems,
//                           onChanged: (dept) {
//                             setState(() {
//                               section = dept;
//                             });
//                           },
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(4.0),
//                         child: ElevatedButton(
//                             onPressed: () {
//                               Get.to(() => const TeacherForm());
//                             },
//                             child: const Padding(
//                               padding: EdgeInsets.all(16.0),
//                               child: Text("Add"),
//                             )),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(4.0),
//                         child: ElevatedButton(
//                             onPressed: () {
//                               setStreamBuilderState!(() {});
//                             },
//                             child: const Padding(
//                               padding: EdgeInsets.all(16.0),
//                               child: Text("Search"),
//                             )),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               StatefulBuilder(builder: (context, setState) {
//                 setStreamBuilderState = setState;
//                 return StreamBuilder<List<Teacher>>(
//                     stream: getStream(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.active &&
//                           snapshot.hasData) {
//                         var list = snapshot.data;
//                         var source = BioSource(list!, context);
//                         return ConstrainedBox(
//                           constraints: BoxConstraints(
//                             minWidth: getWidth(context) * 0.90,
//                             maxWidth: 1980,
//                           ),
//                           child: PaginatedDataTable(
//                             dragStartBehavior: DragStartBehavior.start,
//                             columns: BioSource.getCoumns(EntityType.teacher),
//                             source: source,
//                             rowsPerPage: (getHeight(context) ~/
//                                     kMinInteractiveDimension) -
//                                 5,
//                           ),
//                         );
//                       }
//                       if (snapshot.hasError) {
//                         if (kDebugMode) {
//                           print(snapshot.error);
//                         }
//                         return const Text("Error occured");
//                       }
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     });
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
