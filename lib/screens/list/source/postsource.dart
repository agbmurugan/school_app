import 'package:flutter/material.dart';
import 'package:school_app/constants/constant.dart';
import 'package:school_app/models/response.dart';
import 'package:school_app/screens/Form/post_form.dart';

import '../../../models/post.dart';

class PostSource extends DataTableSource {
  final List<Post> postlist;
  final BuildContext context;

  PostSource(this.postlist, this.context);

  static List<DataColumn> getCoumns() {
    List<DataColumn> columns = [
      const DataColumn(label: Text('SL.No')),
      const DataColumn(label: Text('TITLE')),
      const DataColumn(label: Text('MESSAGE')),
      const DataColumn(label: Text('AUDIENCE')),
      const DataColumn(label: Text('ANNOUNCEMENT DATE')),
      const DataColumn(label: Text('VIEW')),
      const DataColumn(label: Text('DELETE')),
    ];

    return columns;
  }

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= postlist.length) ;
    int sNo = index + 1;
    Post post = postlist[index];
    return DataRow.byIndex(
        index: index,
        color: MaterialStateProperty.all((sNo % 2 == 0) ? Colors.white : const Color.fromARGB(255, 233, 232, 232)),
        cells: [
          DataCell(Text(sNo.toString())),
          DataCell(SizedBox(width: 300, child: Text(post.title))),
          DataCell(Tooltip(
            message: post.content,
            preferBelow: true,
            child: SizedBox(
                width: 600,
                child: Text(
                  post.content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                )),
          )),
          DataCell(Text(post.audience.toString().split('.').last.toUpperCase())),
          DataCell(Text(post.date.toString().substring(0, 10))),
          DataCell(IconButton(
            icon: const Icon(Icons.visibility),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: PostForm(post: post),
                    );
                  });
            },
          )),
          DataCell(IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              var future = firestore
                  .collection('posts')
                  .doc(post.docId)
                  .delete()
                  .then((value) => Result.success("Deleted Successfully"))
                  .onError((error, stackTrace) => Result.error(error.toString()));
              showFutureCustomDialog(
                  context: context,
                  future: future,
                  onTapOk: () {
                    Navigator.of(context).pop();
                  });
            },
          ))
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => postlist.length;

  @override
  int get selectedRowCount => 0;
}
