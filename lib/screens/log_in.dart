import 'dart:ui';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:school_app/constants/constant.dart';
import 'package:school_app/constants/get_constants.dart';
import 'package:school_app/controllers/auth_controller.dart';
import 'package:school_app/widgets/responsivewidget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showPassword = false;
  bool forgotPassword = false;
  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
                Flexible(
                  flex: 1,
                  child: Padding(padding: const EdgeInsets.only(bottom: 50), child: Image.asset('assets/logo.png')),
                ),
                ListTile(title: const Text("Email"), subtitle: TextFormField(controller: emailController)),
                forgotPassword
                    ? Container()
                    : ListTile(
                        title: const Text("Password"),
                        subtitle: TextFormField(
                          controller: passwordController,
                          obscureText: !showPassword,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                  icon: showPassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off))),
                        ),
                      ),
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: SizedBox(
                      height: 50,
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: () {
                          if (forgotPassword) {
                            auth.resetPassword(email: emailController.text.removeAllWhitespace).then((_) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Success"),
                                      content: const Text("An email will be sent, if the address is valid"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Okay"))
                                      ],
                                    );
                                  });
                            });
                          } else {
                            var future = auth.signInWithEmailAndPassword(emailController.text.removeAllWhitespace, passwordController.text);
                            showFutureCustomDialog(context: context, future: future, onTapOk: () => Navigator.of(context).pop());
                          }
                        },
                        child: Text(forgotPassword ? "RESET PASSWORD" : "LOG IN"),
                      ),
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        forgotPassword = !forgotPassword;
                      });
                    },
                    child: Text(forgotPassword ? "Back to sign in" : "Forgot password ?"))
              ]),
            ),
          ),
        ),
        desktop: Scaffold(
          body: Stack(
            children: [
              ConstrainedBox(
                  constraints: const BoxConstraints.expand(),
                  child: Image.asset(
                    'assets/background.png',
                    fit: BoxFit.cover,
                  )),
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.expand(),
                    child: Center(
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        color: Colors.white,
                        elevation: 30,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: getHeight(context) * 0.75,
                            width: getWidth(context) * 0.30,
                            child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
                              Flexible(
                                flex: 2,
                                child: Padding(padding: const EdgeInsets.only(bottom: 50), child: Image.asset('assets/logo.png')),
                              ),
                              ListTile(title: const Text("Email"), subtitle: TextFormField(controller: emailController)),
                              forgotPassword
                                  ? Container()
                                  : ListTile(
                                      title: const Text("Password"),
                                      subtitle: TextFormField(
                                        controller: passwordController,
                                        obscureText: !showPassword,
                                        decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    showPassword = !showPassword;
                                                  });
                                                },
                                                icon: showPassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off))),
                                      ),
                                    ),
                              Flexible(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: SizedBox(
                                    height: 50,
                                    width: double.maxFinite,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (forgotPassword) {
                                          auth.resetPassword(email: emailController.text.removeAllWhitespace).then((_) {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text("Success"),
                                                    content: const Text("An email will be sent, if the address is valid"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: const Text("Okay"))
                                                    ],
                                                  );
                                                });
                                          });
                                        } else {
                                          var future =
                                              auth.signInWithEmailAndPassword(emailController.text.removeAllWhitespace, passwordController.text);
                                          showFutureCustomDialog(context: context, future: future, onTapOk: () => Navigator.of(context).pop());
                                        }
                                      },
                                      child: Text(forgotPassword ? "RESET PASSWORD" : "LOG IN"),
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      forgotPassword = !forgotPassword;
                                    });
                                  },
                                  child: Text(forgotPassword ? "Back to sign in" : "Forgot password ?"))
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        tablet: Scaffold(
          body: Stack(
            children: [
              ConstrainedBox(
                  constraints: const BoxConstraints.expand(),
                  child: Image.asset(
                    'assets/background.png',
                    fit: BoxFit.contain,
                  )),
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.expand(),
                    child: Center(
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        color: Colors.white,
                        elevation: 30,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: getHeight(context) * 0.70,
                            width: getWidth(context) * 0.40,
                            child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
                              Flexible(
                                flex: 2,
                                child: Padding(padding: const EdgeInsets.only(bottom: 50), child: Image.asset('assets/logo.png')),
                              ),
                              ListTile(title: const Text("Email"), subtitle: TextFormField(controller: emailController)),
                              forgotPassword
                                  ? Container()
                                  : ListTile(
                                      title: const Text("Password"),
                                      subtitle: TextFormField(
                                        controller: passwordController,
                                        obscureText: !showPassword,
                                        decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    showPassword = !showPassword;
                                                  });
                                                },
                                                icon: showPassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off))),
                                      ),
                                    ),
                              Flexible(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: SizedBox(
                                    height: 50,
                                    width: double.maxFinite,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (forgotPassword) {
                                          auth.resetPassword(email: emailController.text.removeAllWhitespace).then((_) {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text("Success"),
                                                    content: const Text("An email will be sent, if the address is valid"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: const Text("Okay"))
                                                    ],
                                                  );
                                                });
                                          });
                                        } else {
                                          var future =
                                              auth.signInWithEmailAndPassword(emailController.text.removeAllWhitespace, passwordController.text);
                                          showFutureCustomDialog(context: context, future: future, onTapOk: () => Navigator.of(context).pop());
                                        }
                                      },
                                      child: Text(forgotPassword ? "RESET PASSWORD" : "LOG IN"),
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      forgotPassword = !forgotPassword;
                                    });
                                  },
                                  child: Text(forgotPassword ? "Back to sign in" : "Forgot password ?"))
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
