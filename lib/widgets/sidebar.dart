import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_app/constants/get_constants.dart';
import 'package:school_app/controllers/auth_controller.dart';
import 'package:school_app/controllers/queue_controller.dart';
import 'package:school_app/controllers/session_controller.dart';
import 'package:school_app/models/biodata.dart';
import 'package:school_app/screens/carousel.dart';
import 'package:school_app/screens/dashboard.dart';
import 'package:school_app/screens/list/admin_list.dart';
import 'package:school_app/screens/list/appointmentlist.dart';
import 'package:school_app/screens/list/parent_list.dart';
import 'package:school_app/screens/list/post_list.dart';
import 'package:school_app/screens/list/student_list.dart';
import 'package:school_app/screens/list/teacher_list.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  set index(int number) => session.pageIndex = number;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: session,
        builder: (_) {
          final currentPage = session.pageIndex;
          return Drawer(
            // backgroundColor: Colors.blue.shade50,
            child: ListView(
              children: [
                DrawerHeader(
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                DrawerListTile(
                  leading: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/3408/3408591.png',
                    height: getHeight(context) * 0.03,
                  ),
                  title: "Dashboard",
                  svgSrc: "assets/icons/menu_tran.svg",
                  selected: currentPage == 0,
                  press: () {
                    session.pageIndex = 0;
                    Get.offAllNamed(Dashboard.routeName);
                  },
                ),
                DrawerListTile(
                  leading: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/3829/3829933.png',
                    height: getHeight(context) * 0.03,
                  ),
                  title: "Student List",
                  svgSrc: "assets/icons/menu_tran.svg",
                  selected: currentPage == 1,
                  press: () {
                    session.pageIndex = 1;
                    // Get.offAllNamed(EntityList.routeName, arguments: EntityType.student);
                    Get.offAll(() => const StudentList());
                  },
                ),
                DrawerListTile(
                  leading: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/780/780270.png',
                    height: getHeight(context) * 0.03,
                  ),
                  title: "Parent List",
                  svgSrc: "assets/icons/menu_tran.svg",
                  selected: currentPage == 2,
                  press: () {
                    session.pageIndex = 2;
                    // Get.offAllNamed(EntityList.routeName, arguments: EntityType.parent);
                    Get.offAll(() => const ParentList());
                  },
                ),
                (auth.isAdmin!)
                    ? DrawerListTile(
                        leading: Image.network(
                          'https://cdn-icons-png.flaticon.com/512/4696/4696727.png',
                          height: getHeight(context) * 0.03,
                        ),
                        title: "Teacher List",
                        svgSrc: "assets/icons/menu_tran.svg",
                        selected: currentPage == 3,
                        press: () {
                          session.pageIndex = 3;
                          // Get.offAllNamed(EntityList.routeName, arguments: EntityType.teacher);
                          Get.offAll(() => const TeachersList());
                        },
                      )
                    : Container(),

                DrawerListTile(
                  leading: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/942/942759.png',
                    height: getHeight(context) * 0.03,
                  ),
                  title: "Appointments",
                  svgSrc: "assets/icons/menu_tran.svg",
                  selected: currentPage == 4,
                  press: () {
                    session.pageIndex = 4;
                    Get.offAll(const AppoinmentList());
                    // Get.offAll(() => const Carousel());
                  },
                ),
                DrawerListTile(
                  leading: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/1907/1907440.png',
                    height: getHeight(context) * 0.03,
                  ),
                  title: "Carousel",
                  svgSrc: "assets/icons/menu_tran.svg",
                  // selected: currentPage == 2,
                  press: () {
                    session.showSideBar = false;
                    session.update();

                    double screenWidth = getWidth(context);
                    double screenHeight = getHeight(context);
                    int columns = screenWidth ~/ 464;
                    int rows = screenHeight ~/ 152;
                    QueueController.tileCount = columns * rows;
                    // print(QueueController.tileCount);
                    Get.to(
                      () => const Carousel(),
                    );
                  },
                ),
                DrawerListTile(
                  leading: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/1378/1378644.png',
                    height: getHeight(context) * 0.03,
                  ),
                  title: "Announcements",
                  svgSrc: "assets/icons/menu_tran.svg",
                  selected: currentPage == 6,
                  press: () {
                    session.pageIndex = 6;
                    Get.offAll(const PostList());
                    // Get.offAll(() => const Carousel());
                  },
                ),
                (auth.isAdmin!)
                    ? DrawerListTile(
                        leading: Image.network(
                          'https://cdn-icons-png.flaticon.com/512/6024/6024190.png',
                          height: getHeight(context) * 0.03,
                        ),
                        title: "Admins",
                        svgSrc: "assets/icons/menu_tran.svg",
                        selected: currentPage == 7,
                        press: () {
                          session.pageIndex = 7;
                          Get.offAll(const AdminList());
                          // Get.offAll(() => const Carousel());
                        },
                      )
                    : Container(),
                // DrawerListTile(
                // leading: Image.network(
                //   'https://cdn-icons-png.flaticon.com/512/942/942968.png',
                //   height: getHeight(context) * 0.03,
                // ),
                //   title: "Class",
                //   svgSrc: "assets/icons/menu_tran.svg",
                //   // selected: currentPage == 5,
                //   press: () {
                //     // session.pageIndex = 5;
                //     showDialog(
                //         context: context,
                //         builder: (context) {
                //           return Dialog(child: ClassList());
                //         });
                //     // Get.offAll(() => const Carousel());
                //   },
                // ),
                DrawerListTile(
                  leading: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/1574/1574351.png',
                    height: getHeight(context) * 0.03,
                  ),
                  title: "Log out",
                  svgSrc: "assets/icons/menu_tran.svg",
                  press: () {
                    auth.signOut();
                  },
                ),
              ],
            ),
          );
        });
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
    this.selected = false,
    this.leading,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;
  final bool selected;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selectedColor: Colors.yellowAccent.shade100,
      leading: SizedBox(width: getWidth(context) * 0.02, height: getHeight(context) * 0.03, child: leading),
      onTap: press,
      selected: selected,
      selectedTileColor: Colors.blueAccent.shade100,
      hoverColor: Colors.blue.shade100,
      horizontalTitleGap: 0.0,
      title: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
