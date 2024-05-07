import 'package:flutter/material.dart';
import 'package:school_app/constants/get_constants.dart';
import 'package:school_app/widgets/dashboard/class_list.dart';

class ClassMaster extends StatefulWidget {
  const ClassMaster({Key? key}) : super(key: key);

  @override
  State<ClassMaster> createState() => _ClassMasterState();
}

class _ClassMasterState extends State<ClassMaster> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      if (isMobile(context)) {
        return ClassList();
      } else {
        return Row(children: [
          Expanded(
            flex: 1,
            child: Scaffold(
              body: ClassList(),
              // floatingActionButton: FloatingActionButton(onPressed: () {
              //   showDialog(
              //       context: context,
              //       builder: (context) {
              //         return Dialog(
              //           insetPadding: EdgeInsets.symmetric(
              //             horizontal: getWidth(context) * (1 / 4),
              //           ),
              //           child: ClassList(),
              //         );
              //       });
              // }),
            ),
          ),
          const Expanded(
              flex: 2,
              child: Center(
                child: Text("Under Develpoment"),
              )),
        ]);
      }
    }));
  }
}
