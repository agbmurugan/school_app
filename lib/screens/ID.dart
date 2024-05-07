// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:school_app/models/student.dart';

class Idcard extends StatelessWidget {
  final Student student;
  final String string;

  const Idcard({Key? key, required this.student, required this.string}) : super(key: key);

  // getCarTiles() {
  //   List<Widget> tiles = [];
  //   for (var element in student.carNumbers) {
  //     if (element.isNotEmpty) {
  //       tiles.add(ListTile(
  //         leading: const Icon(CupertinoIcons.car_detailed, color: Colors.black),
  //         title: Text(element, style: const TextStyle(fontSize: 18)),
  //       ));
  //     }
  //   }
  //   return tiles;
  // }

  // getParentTiles() {
  //   List<TableRow> tiles = [];
  //   if ((student.father ?? '').isNotEmpty) {
  //     tiles.add(TableRow(children: [
  //       TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Text("Father", style: GoogleFonts.montserrat(fontSize: 18))),
  //       Text(student.father!, style: const TextStyle(fontSize: 18)),
  //     ]));
  //   }
  //   if ((student.mother ?? '').isNotEmpty) {
  //     tiles.add(TableRow(children: [
  //       TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Text("Mother", style: GoogleFonts.montserrat(fontSize: 18))),
  //       Text(student.mother!, style: const TextStyle(fontSize: 18)),
  //     ]));
  //   }
  //   if ((student.guardian ?? '').isNotEmpty) {
  //     tiles.add(TableRow(children: [
  //       TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Text("Guardian", style: GoogleFonts.montserrat(fontSize: 18))),
  //       Text(student.guardian!, style: const TextStyle(fontSize: 18)),
  //     ]));
  //   }
  //   return tiles;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            Container(
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.width,
                color: Colors.grey.shade200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage('https://picsum.photos/536/354'),
                          // backgroundColor: Colors.black,
                          maxRadius: double.maxFinite,
                        ),
                      ),
                    ),
                    Text(
                      student.name.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 50),
                    ),
                    Text(
                      student.icNumber.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.blueAccent),
                    ),
                    const Divider(),
                    DataTable(
                      columns: [
                        DataColumn(
                          label: Text.rich(TextSpan(text: 'CLASS', style: GoogleFonts.montserrat(color: Colors.blueAccent), children: [
                            TextSpan(
                              text: " : ${student.studentClass}",
                              style: GoogleFonts.montserrat(fontSize: 18, color: Colors.black),
                            )
                          ])),
                        ),
                        const DataColumn(label: Text('')),
                        DataColumn(
                          label: Text.rich(TextSpan(text: 'SECTION', style: GoogleFonts.montserrat(color: Colors.blueAccent), children: [
                            TextSpan(
                              text: " : ${student.section}",
                              style: GoogleFonts.montserrat(fontSize: 18, color: Colors.black),
                            )
                          ])),
                        ),
                      ],
                      rows: const [],
                    ),
                    const Divider(),
                  ],
                )),
            Positioned(
              right: 16,
              child: StatefulBuilder(builder: ((context, setState) {
                return Text(string);
              })),
            ),
          ],
        ),
      ),
    ));
  }
}
