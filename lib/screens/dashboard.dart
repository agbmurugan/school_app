import 'package:flutter/material.dart';
import 'package:school_app/constants/get_constants.dart';
import 'package:school_app/widgets/theme.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  static String routeName = '/Dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: getColor(context).tertiaryContainer.withOpacity(0.1),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Dashboard',
                  style: getText(context).headline6!.apply(color: getColor(context).primary),
                ),
              ),
              const CustomLayout(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomeTile(),
                  CustomeTile(),
                  CustomeTile(),
                  CustomeTile(),
                ],
              ),
              Center(
                child: SizedBox(
                  width: responsiveSize(context, getWidth(context) * 0.80, getWidth(context) * 0.80, getWidth(context) * 0.90),
                  child: CustomLayout(children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 5,
                            child: SizedBox(
                              height: getHeight(context) * 0.33,
                              width: isMobile(context) ? getWidth(context) * 0.90 : getWidth(context) * 0.54,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 5,
                            child: SizedBox(
                              height: getHeight(context) * 0.33,
                              width: responsiveSize(context, getWidth(context) * 0.54, getWidth(context) * 0.54, getWidth(context) * 0.90),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 5,
                        child: SizedBox(
                            height: getHeight(context) * 0.68,
                            width: responsiveSize(context, getWidth(context) * 0.20, getWidth(context) * 0.30, getWidth(context) * 0.90)),
                      ),
                    )
                  ], mainAxisAlignment: MainAxisAlignment.spaceAround),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomeTile extends StatelessWidget {
  const CustomeTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        child: SizedBox(
            height: getHeight(context) * 0.15,
            width: responsiveSize(context, getWidth(context) * 0.16, getWidth(context) * 0.20, getWidth(context) * 0.90)),
      ),
    );
  }
}

// Row(
// children: [
// Expanded(child: ClassList()),
// const Expanded(child: QueueList()),
// const Expanded(child: Preview()),
// ],
// )
