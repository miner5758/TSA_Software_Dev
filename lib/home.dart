import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:app_usage/app_usage.dart';

Future<Duration> _getUsageStats() async {
  List<AppUsageInfo> _infos = [];
  Duration combined = Duration();
  try {
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(Duration(hours: 24));
    List<AppUsageInfo> infoList =
        await AppUsage().getAppUsage(startDate, endDate);
    _infos = infoList;

    for (var info in infoList) {
      combined += info.usage;
      //print(info.usage.inHours);
    }
  } on AppUsageException catch (exception) {
    print(exception);
  }
  return combined;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SecondScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: FlutterLogo(size: MediaQuery.of(context).size.height));
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
                      future: _getUsageStats(),
                      builder: (context, AsyncSnapshot lnapshots) {
                        if (lnapshots.hasData) {
                  
                            return Scaffold(
              body: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff4169e1),
                        Color(0xffFFE5B4),
                      ],
                      stops: [0, 0],
                    ),
                  ),
                  child: ListView.builder(
                      padding: const EdgeInsets.all(1.0),
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Column(children: [    
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .10),                  
                          Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * .20,
                              child: Card(
                                  child: InkWell(
                                splashColor: Colors.blue,
                                onTap: () {},
                                child: Row(children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 19.0),
                                      child: Center(child:Text(
                                        "Total Screen time: ${lnapshots.data.inHours}",
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      )
                                    ),
                                  ),
                                  
                                ]),
                              )))
                        ]);
                      })));
                        } else if (lnapshots.hasError) {
                          return Text("${lnapshots.error}");
                        }
                        // By default show a loading spinner.
                        return const CircularProgressIndicator();
                      });
                
  }
}
