import 'package:flutter/material.dart';
import 'package:school_app/controllers/queue_controller.dart';
import 'package:school_app/models/student.dart';

class StudentTile extends StatelessWidget {
  const StudentTile({
    Key? key,
    required this.student,
    required this.string,
  }) : super(key: key);

  final Student student;
  final String string;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: const Color(0xFFF5F5F5),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 300),
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.15,
                        backgroundImage: (student.imageUrl ?? '').isNotEmpty
                            ? NetworkImage(student.imageUrl!)
                            : NetworkImage('https://i.pravatar.cc/3${student.icNumber}'),
                      ),
                    ),
                  )),
              Expanded(
                  flex: 5,
                  child: ListTile(
                    enabled: true,
                    title: Text(
                      student.name,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    subtitle: Table(
                      columnWidths: const {
                        0: FixedColumnWidth(40),
                      },
                      children: [
                        // TableRow(
                        //   children: [
                        //     const Text("IC"),
                        //     Text(
                        //       student.icNumber,
                        //       style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.grey),
                        //     ),
                        //   ],
                        // ),
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                "CLASS : " + student.studentClass + " - " + student.section,
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    // trailing: ElevatedButton(
                    //   style: ButtonStyle(
                    //     backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.tertiaryContainer),
                    //     shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                    //   ),
                    //   onPressed: () {},
                    //   child: Text(
                    //     string,
                    //   ),
                    // ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
