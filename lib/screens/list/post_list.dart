import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_app/constants/constant.dart';
import 'package:school_app/controllers/auth_controller.dart';
import 'package:school_app/models/post.dart';
import 'package:school_app/screens/Form/post_form.dart';
import 'package:school_app/screens/list/source/postsource.dart';

class PostList extends StatefulWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  int pageNumber = 0;

  Query<Map<String, dynamic>> get posts {
    if (auth.isAdmin ?? false) {
      return firestore.collection('posts');
    } else {
      return firestore
          .collection('posts')
          .where('search', arrayContainsAny: [Audience.all.index, Audience.teachers.index, auth.currentUser?.uid ?? '']);
    }
  }

  @override
  void initState() {
    fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    toDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 1).subtract(const Duration(days: 1));
    fromDateControler.text = fromDate.toString().substring(0, 10);
    toDateControler.text = toDate.toString().substring(0, 10);
    super.initState();
  }

  late DateTime fromDate;
  late DateTime toDate;

  final TextEditingController fromDateControler = TextEditingController();
  final TextEditingController toDateControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: posts.orderBy('date', descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
            List<Post> list = snapshot.data!.docs.map((e) => Post.fromJson(e.data(), e.id)).toList();
            list = list.where((element) => element.date.isAfter(fromDate)).toList();
            list = list.where((element) => element.date.isBefore(toDate)).toList();
            var source = PostSource(list, context);
            return Table(
              children: [
                TableRow(
                  children: [
                    PaginatedDataTable(
                      dataRowHeight: kMinInteractiveDimension * 1.5,
                      header: const Text("Announcements"),
                      actions: [
                        SizedBox(
                            width: 200,
                            child: ListTile(
                              title: TextFormField(
                                controller: fromDateControler,
                                readOnly: true,
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        onPressed: () async {
                                          var date = await showDatePicker(
                                              context: context, initialDate: fromDate, firstDate: DateTime(2000), lastDate: DateTime(2100));
                                          setState(() {
                                            fromDate = date ?? fromDate;
                                            fromDateControler.text = fromDate.toString().substring(0, 10);
                                          });
                                        },
                                        icon: const Icon(Icons.calendar_month))),
                              ),
                            )),
                        SizedBox(
                            width: 200,
                            child: ListTile(
                              title: TextFormField(
                                controller: toDateControler,
                                readOnly: true,
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        onPressed: () async {
                                          var date = await showDatePicker(
                                              context: context, initialDate: toDate, firstDate: DateTime(2000), lastDate: DateTime(2100));
                                          setState(() {
                                            toDate = date ?? toDate;
                                            toDateControler.text = toDate.toString().substring(0, 10);
                                          });
                                        },
                                        icon: const Icon(Icons.calendar_month))),
                              ),
                            )),
                        ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const Dialog(
                                      child: PostForm(),
                                    );
                                  });
                            },
                            child: const Text("Add"))
                      ],
                      columns: PostSource.getCoumns(),
                      source: source,
                    ),
                  ],
                ),
              ],
            );
          }
          if (snapshot.hasError) {
            return Center(child: SelectableText(snapshot.error.toString()));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class PostTile extends StatelessWidget {
  const PostTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
