import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:school_app/constants/constant.dart';
import 'package:school_app/controllers/parent_controller.dart';
import 'package:school_app/models/biodata.dart';
import 'package:school_app/models/parent.dart';
import 'package:school_app/screens/list/source/bio_source.dart';

import '../../constants/get_constants.dart';

class ParentList extends StatefulWidget {
  const ParentList({Key? key}) : super(key: key);

  static const routeName = '/parentList';
  @override
  State<ParentList> createState() => _ParentListState();
}

class _ParentListState extends State<ParentList> {
  String? className;
  String? search;
  String? section;

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(isMobile(context) ? 2 : 8),
        child: StreamBuilder<List<Parent>>(
            initialData: ParentController.parentsList.toList(),
            stream: getStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
                var list = snapshot.data;
                // if ((search ?? '').isNotEmpty) {
                //   list = list!.where((element) => element.name.toLowerCase().contains(search!.toLowerCase())).toList();
                // }

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
                              const Text("Parents List"),
                              Expanded(child: Container()),
                              SizedBox(
                                  height: getHeight(context) * 0.08,
                                  width: isMobile(context) ? getWidth(context) * 0.80 : getWidth(context) * 0.20,
                                  child: Center(
                                    child: TextFormField(
                                      controller: searchController,
                                      onChanged: ((value) {
                                        if (value.isEmpty) {
                                          setState(() {});
                                        }
                                      }),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: getColor(context).secondary,
                                        ),
                                        border: const OutlineInputBorder(),
                                      ),
                                    ),
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {});
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text("Search"),
                                    )),
                              ),
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
                          columns: BioSource.getCoumns(EntityType.parent),
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

  getStream() {
    Query<Map<String, dynamic>> query = firestore.collection('parents');
    if (searchController.text.isNotEmpty) {
      query = query.where('search', arrayContains: searchController.text.toLowerCase());
    }
    return query.snapshots().map((event) => event.docs.map((e) => Parent.fromJson(e.data())).toList());
  }
}
