import 'package:flutter/material.dart';
import '../../../models/parent.dart';

class ParentSource extends DataTableSource {
  final List<Parent> parents;
  final BuildContext context;

  ParentSource(this.parents, this.context);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= parents.length) return null;
    final parent = parents[index];

    return DataRow.byIndex(cells: [
      DataCell(IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          // controller.change();
        },
      )),
      DataCell(IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          parent.controller.delete();
        },
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => parents.length;

  @override
  int get selectedRowCount => 0;
}
