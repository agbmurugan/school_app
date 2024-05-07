import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:school_app/constants/get_constants.dart';
import 'package:school_app/controllers/auth_controller.dart';
import 'package:school_app/controllers/session_controller.dart';
import 'package:school_app/widgets/dashboard/class_list.dart';
import '../widgets/sidebar.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
          init: session,
          builder: (_) {
            if (session.session.isAdmin == null || session.session.isAdmin == false) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("The credentials you have entered does not hold admin priviliges."),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          auth.signOut();
                        },
                        child: const Text("Logout"),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Row(
              children: [
                (isDesktop(context) && session.showSideBar)
                    ? const Expanded(
                        flex: 1,
                        child: Card(elevation: 10, child: SideMenu()),
                      )
                    : Container(),
                Expanded(
                    flex: 5,
                    child: Scaffold(
                      // appBar: session.pageIndex == 9
                      //     ? null
                      //     : AppBar(
                      //         actions: [
                      //           IconButton(
                      //               iconSize: getWidth(context) * 0.03,
                      //               onPressed: () {},
                      //               icon: Image.network(
                      //                 'https://cdn-icons-png.flaticon.com/512/7650/7650798.png',
                      //               )),
                      //           IconButton(
                      //               iconSize: getWidth(context) * 0.03,
                      //               onPressed: () {},
                      //               icon: Image.network(
                      //                 'https://cdn-icons-png.flaticon.com/512/7650/7650798.png',
                      //               )),
                      //           IconButton(
                      //               iconSize: getWidth(context) * 0.03,
                      //               onPressed: () {},
                      //               icon: Image.network(
                      //                 'https://cdn-icons-png.flaticon.com/512/7650/7650798.png',
                      //               )),
                      //         ],
                      //       ),
                      appBar: AppBar(
                        title: const Text("SAINT SCHOOL ADMIN"),
                        centerTitle: true,
                      ),
                      drawer: isDesktop(context) ? null : const SideMenu(),
                      body: child,
                    )),
              ],
            );
          }),
    );
  }
}
