// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:app_usage/app_usage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'sleep.dart';
import 'authentication_service.dart';

import 'alarms.dart';



int age = 17;

DateTime _now = DateTime.now();
DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
DateTime _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

final FirebaseAuth auth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;

String formatTimestampdate(Timestamp timestamp) {
  var format = DateFormat('y-M-d'); // <- use skeleton here
  return format.format(timestamp.toDate());
}

String formatTimestamptime(Timestamp timestamp) {
  var format = DateFormat('hh:mm a'); // <- use skeleton here
  return format.format(timestamp.toDate());
}


String? inputData() {
  final User? user = auth.currentUser;
  final uid = user?.uid;
  return uid;
}

Future<List<Object?>> _gettata(String? iD) async {
  CollectionReference collectionRef =
      db.collection("Users").doc("$iD").collection("Alarms");
  // Get docs from collection reference
  QuerySnapshot querySnapshot = await collectionRef.where('time', isGreaterThanOrEqualTo: _start) 
           .where('time', isLessThanOrEqualTo: _end)
           .orderBy('time')
           .where("Active", isEqualTo: true) 
           .get();

  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

  return (allData);
}


Future<List<Object?>> _getbedtime(String? iD) async {
  CollectionReference collectionRef =
      db.collection("Users").doc("$iD").collection("Bedtimes");
  // Get docs from collection reference
  QuerySnapshot querySnapshot = await collectionRef
           .orderBy('time')
           .where("Active", isEqualTo: true) 
           .get();

  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

  return (allData);
}


Future<List<Object?>> _gettask(String? iD) async {
  CollectionReference collectionRef =
      db.collection("Users").doc("$iD").collection("Tasks");
  // Get docs from collection reference
  QuerySnapshot querySnapshot = await collectionRef.where('When', isGreaterThanOrEqualTo: _start) 
           .where('When', isLessThanOrEqualTo: _end)
           .orderBy('When')
           .get();

  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

  return (allData);
}



Future<Duration> _getUsageStats() async {
  Duration combined = const Duration();
  try {
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(const Duration(hours: 24));
    List<AppUsageInfo> infoList =
        await AppUsage().getAppUsage(startDate, endDate);
    for (var info in infoList) {
      combined += info.usage;
      //print(info.usage.inHours);
    }
  } on AppUsageException catch (exception) {
    print(exception);
  }
  return combined;
}




class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MyStatefulWidgetsecond(),
    );
  }
}


class MyStatefulWidgetfirst extends StatefulWidget {
   const MyStatefulWidgetfirst({super.key});
  @override
  State<MyStatefulWidgetfirst> createState() => _MyStatefulWidgetStatefirst();
}

class MyStatefulWidgetsecond extends StatefulWidget {
   const MyStatefulWidgetsecond({super.key});
  @override
  State<MyStatefulWidgetsecond> createState() => _MyStatefulWidgetStatesecond();
}

class _MyStatefulWidgetStatefirst extends State<MyStatefulWidgetfirst> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MyStatefulWidgetsecond())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: FlutterLogo(size: MediaQuery.of(context).size.height));
  }
}


class _MyStatefulWidgetStatesecond extends State<MyStatefulWidgetsecond> {

  TextEditingController namecontroller = TextEditingController();
TextEditingController descriptioncontroller = TextEditingController();

  int _selectedIndex = 1;
  final pages = [
    const Sleeppage(),
    const MyHomePage(),
    const Alarmpage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void updatetask(String? iD,bool? value,String dic){
    db.collection('Users').doc("$iD").collection("Tasks").doc(dic).update({'Done': value ?? false});

}

void createtask(String? iD,DateTime date){
  
    db.collection('Users').doc("$iD").collection("Tasks").doc(namecontroller.text).set(
      {
        "Des":descriptioncontroller.text,
        "Done":false,
        "When":Timestamp.fromDate(date),
        "name":namecontroller.text}
        );

}
  
  
  
  @override
  
  
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: const Color.fromARGB(255, 230,230,250),
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(bodySmall: const TextStyle(color: Color.fromARGB(255, 158, 158, 158)))),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.bed),
              label: 'Sleep',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.alarm_add),
              label: 'Alarms',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
              body: Center(
                child: _selectedIndex != 1
            ? pages[_selectedIndex]
            : 
              Container(
                  decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("lib/images/back.jpg"),
                fit: BoxFit.cover),
          ),
                  child: Column(
                          children: [    
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .10),
                        FutureBuilder(
                      future: db.collection("Users").doc(inputData()).get().then((value) {
          return value.data()!["Username"];
        }),
                      builder: (context, AsyncSnapshot snapshots){
                         if (snapshots.hasData) {
                      return Center(child:Text(
                                        "Welcome back ${snapshots.data}",
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
                          ), //tdfedcd
                          
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
                                onTap: () {
                                  print("hi");
                                            context
                                                .read<AuthenticationService>()
                                                .signOut();
                                            Navigator.popUntil(
                                                context,
                                                (Route<dynamic> predicate) =>
                                                    predicate.isFirst);
                                          },
                                child: Row(children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 19.0),
                                      child: Center(child:Text(
                                        "Your screen time: ${lnapshots.data.inHours}h. \nRecommended: ${lnapshots.data.inHours - 1}h.\nTry lessening your screen time, blue light sleep harder.",
                                        style:  TextStyle(
                                            fontSize: MediaQuery.of(context).size.height * .016,
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
                                onTap: () {
                                  print("hi");
                                            context
                                                .read<AuthenticationService>()
                                                .signOut();
                                            Navigator.popUntil(
                                                context,
                                                (Route<dynamic> predicate) =>
                                                    predicate.isFirst);
                                          },
                                child: Row(children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 19.0),
                                      child: Center(child:Text(
                                        "You have a screen time of ${lnapshots.data.inHours}h, keep up the good work!",
                                        style:  TextStyle(
                                            fontSize: MediaQuery.of(context).size.height * .2,
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
                                onTap: () {
                                  print("hi");
                                            context
                                                .read<AuthenticationService>()
                                                .signOut();
                                            Navigator.popUntil(
                                                context,
                                                (Route<dynamic> predicate) =>
                                                    predicate.isFirst);
                                          },
                                child: Row(children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 19.0),
                                      child: Center(child:Text(
                                        "Your screen time: ${lnapshots.data.inHours}h. \nRecommended: ${lnapshots.data.inHours - 2}h.\nTry lessening your screen time, blue light sleep harder.",
                                        style:  TextStyle(
                                            fontSize: MediaQuery.of(context).size.height * .016,
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
                                onTap: () {
                                  print("hi");
                                            context
                                                .read<AuthenticationService>()
                                                .signOut();
                                            Navigator.popUntil(
                                                context,
                                                (Route<dynamic> predicate) =>
                                                    predicate.isFirst);
                                          },
                                child: Row(children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 19.0),
                                      child: Center(child:Text(
                                        "You have a screen time of ${lnapshots.data.inHours} Hours, keep it up!",
                                        style:  TextStyle(
                                            fontSize: MediaQuery.of(context).size.height * .2,
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
                                onTap: () {
                                  print("hi");
                                            context
                                                .read<AuthenticationService>()
                                                .signOut();
                                            Navigator.popUntil(
                                                context,
                                                (Route<dynamic> predicate) =>
                                                    predicate.isFirst);
                                          },
                                child: Row(children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 19.0),
                                      child: Center(child:Text(
                                        "Your screen time: ${lnapshots.data.inHours}h. \nRecommended: ${lnapshots.data.inHours - 3}h.\nTry lessening your screen time, blue light sleep harder.",
                                        style:  TextStyle(
                                            fontSize: MediaQuery.of(context).size.height * .016,
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
                                onTap: () {
                                  print("hi");
                                            context
                                                .read<AuthenticationService>()
                                                .signOut();
                                            Navigator.popUntil(
                                                context,
                                                (Route<dynamic> predicate) =>
                                                    predicate.isFirst);
                                          },
                                child: Row(children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 19.0),
                                      child: Center(child:Text(
                                        "You have a screen time of ${lnapshots.data.inHours} Hours, keep it up!",
                                        style:  TextStyle(
                                            fontSize: MediaQuery.of(context).size.height * .2,
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
                              height: MediaQuery.of(context).size.height * .01),

                              Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * .20,
                              child: Row(children: <Widget>[
                                  FutureBuilder(
                      future: _gettata(inputData()),
                      builder: (context, AsyncSnapshot lnapshots){
                         if (lnapshots.hasData) {
                          if (lnapshots.data.length == 0) {
                            return Container(
                    width:  MediaQuery.of(context).size.width / 2.01,
                    height: MediaQuery.of(context).size.height / 6.3,
                    decoration: const BoxDecoration(
                    ),
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text(
                            'Upcoming Alarms',
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .02),
                          
                          const Center(child: Text(
                           "None",
                              )),
                        ],
                      ),
                    ),
                  );
                          }else{
                            return Container(
                    width:  MediaQuery.of(context).size.width / 2.01,
                    height: MediaQuery.of(context).size.height / 6.3,
                    decoration: const BoxDecoration(
                    ),
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text(
                            'Upcoming Alarms',
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .02),
                          Expanded(child:
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: lnapshots.data.length,
                            itemBuilder: (context, index){
                              return Center(child: Text(
                           lnapshots.data[index]["Name"] + ": " + formatTimestamptime(lnapshots.data[index]["time"]).toString(),
                              ));
                            }
                          ),
                          )
                        ],
                      ),
                    ),
                  );
                          }
                      } else if (lnapshots.hasError) {
                        print("${lnapshots.error}");
                          return Container(
                    width:  MediaQuery.of(context).size.width / 2.01,
                    height: MediaQuery.of(context).size.height / 6.3,
                    decoration: const BoxDecoration(
                    ),
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text(
                            'Upcoming Alarms',
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .02),
                          
                          Center(child: Text(
                           "${lnapshots.error}",
                              )),
                        ],
                      ),
                    ),
                  );
                        }
                        // By default show a loading spinner.
                        return const CircularProgressIndicator();
                      }
                            ),
                                  
                                  FutureBuilder(
                      future: _getbedtime(inputData()),
                      builder: (context, AsyncSnapshot lnapshots){
                         if (lnapshots.hasData) {
                          if (lnapshots.data.length == 0) {
                            return Container(
                    width:  MediaQuery.of(context).size.width / 2.01,
                    height: MediaQuery.of(context).size.height / 6.3,
                    decoration: const BoxDecoration(
                    ),
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,

                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text(
                            'Upcoming Bedtime',
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .02),
                          
                          const Center(child: Text(
                           "None",
                              )),
                        ],
                      ),
                    ),
                  );
                          }else{
                            return Container(
                    width:  MediaQuery.of(context).size.width / 2.01,
                    height: MediaQuery.of(context).size.height / 6.3,
                    decoration: const BoxDecoration(
                    ),
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text(
                            'Upcoming Bedtime',
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .02),
                          Expanded(child: 
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: lnapshots.data.length,
                            itemBuilder: (context, index){
                              return Center(child: Text(
                           formatTimestamptime(lnapshots.data[index]["time"]).toString(),
                              ));
                            }
                          )
                          ),
                        ],
                      ),
                    ),
                  );
                          }
                      } else if (lnapshots.hasError) {
                        print("${lnapshots.error}");
                          return Container(
                    width:  MediaQuery.of(context).size.width / 2.01,
                    height: MediaQuery.of(context).size.height / 6.3,
                    decoration: const BoxDecoration(
                    ),
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text(
                            'Upcoming Bedtime',
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .02),
                          
                          Center(child: Text(
                           "${lnapshots.error}",
                              )),
                        ],
                      ),
                    ),
                  );
                        }
                        // By default show a loading spinner.
                        return const CircularProgressIndicator();
                      }
                            ),
                              
                                ]),
                              ),
                                                        
                          
                        
                              
                  SizedBox(
                      height: MediaQuery.of(context).size.height * .05),
                  const Center(child:Text(
                                        "Task for Today: ",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ),
                ElevatedButton(
  onPressed: () {


showDialog(
  context: context,
  builder: (context) {
    DateTime date = DateTime.now();
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
                    scrollable: true,
                    title: const Text('Create Task'),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: namecontroller,
                              decoration: const InputDecoration(
                                
                                labelText: 'Name',
                                icon: Icon(Icons.account_box),
                              ),
                              validator: (value) {
  if (value!.isEmpty) {
    return 'Enter Task Name';
   }
return null;
   },
                            ),
                            TextFormField(
                              controller: descriptioncontroller,
                              decoration: const InputDecoration(
                                labelText: 'Description',
                                icon: Icon(Icons.email),
                                
                              ),
                              validator: (value) {
  if (value!.isEmpty) {
    return 'Enter Task Name';
   }
return null;
   },
                            ),

                            TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: DateFormat('MM/dd/yyyy - hh:mm a').format(date),
                                icon: const Icon(Icons.calendar_month),
                              ),
                            ),

                          
                            
                            ElevatedButton(
  onPressed: () {
    
    showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    title: const Text('Pick Date'),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.dateAndTime,
                
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() {
                    date = newDateTime;
                  });
                  
                },
                use24hFormat: false,
                minuteInterval: 1,
              ),
            )
                    )
                  );
  });
  
  },
  child: const Text('Pick Date'),
),
                        
                             
                          ],
                        ),
                      ),
                    ),
                     actions: [
                      Row(children: <Widget>[
                        ElevatedButton(
                          child: const Text("Cancel"),
                          onPressed: () {
                            namecontroller.text = "";
                            descriptioncontroller.text = "";
                           Navigator.pop(context);
                          }),

                        ElevatedButton(
                          child: const Text("Submit"),
                          onPressed: () {

                           createtask(inputData(),date);
                           Navigator.pop(context);
                           namecontroller.text = "";
                            descriptioncontroller.text = "";
                           Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => super.widget));
                          }),
                      ])
                      
                          
                    ],
                  );
      },
    );
  },
);

            
          },
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0x00218380), // Change color as need
    foregroundColor: Colors.white, // Change text color as needed
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    minimumSize: Size(MediaQuery.of(context).size.width/2, 50), // Adjust size as needed
  ),
  child: const Text('Create Task'),
),
SizedBox(
                      height: MediaQuery.of(context).size.height * .02),

                Expanded(
          child: SizedBox(
            height: 200.0,
            child:
                 FutureBuilder(
                      future: _gettask(inputData()),
                      builder: (context, AsyncSnapshot snapshots){
                         if (snapshots.hasData) {
                      return ListView.builder(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            itemCount: snapshots.data.length,
                            itemBuilder: (context, index){
                      return Card(
                        color: Colors.white,
                        child:
                      CheckboxListTile(
                  title:  Text(snapshots.data[index]['name'].toString()),
                  subtitle:  Text(snapshots.data[index]['Des'].toString()),
                  secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                  value: snapshots.data[index]["Done"],
                  onChanged: (bool? value) {
                    updatetask(inputData(),value,snapshots.data[index]["name"].toString());
                    setState(() {});
                  },
                      )
                );
                      
                         }
                      );
                         } else if (snapshots.hasError) {
                          return Text("${snapshots.error}");
                        }
                        return const CircularProgressIndicator();
                      }
                          ),
          )
                ),
                SizedBox(
                      height: MediaQuery.of(context).size.height * .02),

                        ])
                      
                      
                      )
              )
                      );
                      
                
  }
}
