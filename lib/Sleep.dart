import 'package:flutter/material.dart';

class Sleeppage extends StatelessWidget {
  const Sleeppage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyStatefulWidgetfirst(),
    );
  }
}

class MyStatefulWidgetfirst extends StatefulWidget {
   MyStatefulWidgetfirst({Key? key}) : super(key: key);
  @override
  State<MyStatefulWidgetfirst> createState() => _MyStatefulWidgetStatefirst();
}

class _MyStatefulWidgetStatefirst extends State<MyStatefulWidgetfirst> {
  @override
  void initState() {
    super.initState();

  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
                  decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  const Color(0xFF3366FF),
                  const Color(0xFF00CCFF),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
      )

    );
  }
}