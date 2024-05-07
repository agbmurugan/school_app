import 'package:flutter/material.dart';

class Preview extends StatelessWidget {
  const Preview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dashboard"),
          centerTitle: true,
        ),
        body: const Center(
          child: Text("Under Development"),
        ),
      ),
    );
  }
}
