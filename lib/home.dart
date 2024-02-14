import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:app_usage/app_usage.dart';
int age = 17;
bool _value = false;
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
                  child: ListView.builder(
                      padding: const EdgeInsets.all(1.0),
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Column(
                          
                          children: [    
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .10),
                        FutureBuilder(
                      future: _getUsageStats(),
                      builder: (context, AsyncSnapshot snapshots){
                         if (snapshots.hasData) {
                      return Center(child:Text(
                                        "Welcome back bro!",
                                        style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      );
                         } else if (snapshots.hasError) {
                          return Text("${snapshots.error}");
                        }
                        return const CircularProgressIndicator();
                      }
                          ),
                          
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .05),                  
                          
                                    
                          FutureBuilder(
                      future: _getUsageStats(),
                      builder: (context, AsyncSnapshot lnapshots) {
                        if (lnapshots.hasData) {
                          if(age >= 2 && age < 5){
                            if(lnapshots.data.inHours > 1){
                        return Container(
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
                                      padding: const EdgeInsets.only(left: 19.0),
                                      child: Center(child:Text(
                                        "You have a screen time of ${lnapshots.data.inHours} Hours. You are ${lnapshots.data.inHours - 1} over the recommended screen time for someone you age it is recommended that you get less than 1 hour of screen time per day. Blue light can negatively affect your ability to fall alseep so work on reducing it anyway you can.",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      )
                                    ),
                                  ),
                                  
                                ]),
                              )));
                            } else{
                              return Container(
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
                                      padding: const EdgeInsets.only(left: 19.0),
                                      child: Center(child:Text(
                                        "You have a screen time of ${lnapshots.data.inHours} Hours, keep it up!",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      )
                                    ),
                                  ),
                                  
                                ]),
                              )));
                            }
                          } else if(age >= 5 && age <= 17){
                            if(lnapshots.data.inHours > 2){
                        return Container(
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
                                      padding: const EdgeInsets.only(left: 19.0),
                                      child: Center(child:Text(
                                        "You have a screen time of ${lnapshots.data.inHours} Hours. You are ${lnapshots.data.inHours - 2} over the recommended screen time for someone you age it is recommended that you get less than 2 hours of screen time per day. Blue light can negatively affect your ability to fall alseep so work on reducing it anyway you can.",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      )
                                    ),
                                  ),
                                  
                                ]),
                              )));
                            } else{
                               return Container(
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
                                      padding: const EdgeInsets.only(left: 19.0),
                                      child: Center(child:Text(
                                        "You have a screen time of ${lnapshots.data.inHours} Hours, keep it up!",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      )
                                    ),
                                  ),
                                  
                                ]),
                              )));
                            }
                          } else if(age>=18){
                            if(lnapshots.data.inHours > 3){
                        return Container(
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
                                      padding: const EdgeInsets.only(left: 19.0),
                                      child: Center(child:Text(
                                        "You have a screen time of ${lnapshots.data.inHours} Hours. You are ${lnapshots.data.inHours - 3} over the recommended screen time for someone you age it is recommended that you get less than 3 hours of screen time per day. Blue light can negatively affect your ability to fall alseep so work on reducing it anyway you can.",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      )
                                    ),
                                  ),
                                  
                                ]),
                              )));
                            } else{
                               return Container(
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
                                      padding: const EdgeInsets.only(left: 19.0),
                                      child: Center(child:Text(
                                        "You have a screen time of ${lnapshots.data.inHours} Hours, keep it up!",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      )
                                    ),
                                  ),
                                  
                                ]),
                              )));
                            }
                          }
                        } else if (lnapshots.hasError) {
                          return Text("${lnapshots.error}");
                        }
                        // By default show a loading spinner.
                        return const CircularProgressIndicator();
                      }
                          ),
                          
                              SizedBox(
                              height: MediaQuery.of(context).size.height * .05),

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
                                      padding: const EdgeInsets.only(left: 19.0),
                                      child: Center(child:Text(
                                        "Upcoming Alarms times: ",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      )
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 19.0),
                                      child: Center(child:Text(
                                        "Upcoming Bed times: ",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      )
                                    ),
                                  ),
                                  
                                ]),
                              ))),
                              CheckboxListTile(
                  title: const Text('GeeksforGeeks'),
                  subtitle: const Text('A computer science portal for geeks.'),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                  selected: _value,
                  value: _value,
                  onChanged: (bool value) {
                    setState(() {
                      _value = value;
                    });
                  },
                ),
                        ]);
                      })));
                      
                
  }
}
