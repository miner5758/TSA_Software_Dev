import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:app_usage/app_usage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'Sleep.dart';

int age = 17;
List<bool> _checked = [];

DateTime _now = DateTime.now();
DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
DateTime _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

final FirebaseAuth auth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;

String formatTimestampdate(Timestamp timestamp) {
  var format = new DateFormat('y-M-d'); // <- use skeleton here
  return format.format(timestamp.toDate());
}

String formatTimestamptime(Timestamp timestamp) {
  var format = new DateFormat('hh:mm a'); // <- use skeleton here
  return format.format(timestamp.toDate());
}


String? inputData() {
  final User? user = auth.currentUser;
  final uid = user?.uid;
  return uid;
}

Future<List<Object?>> _gettata(String? iD) async {
  CollectionReference _collectionRef =
      db.collection("Users").doc("$iD").collection("Alarms");
  // Get docs from collection reference
  QuerySnapshot querySnapshot = await _collectionRef.where('time', isGreaterThanOrEqualTo: _start) 
           .where('time', isLessThanOrEqualTo: _end)
           .orderBy('time')
           .where("Active", isEqualTo: true) 
           .get();

  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

  return (allData);
}


Future<List<Object?>> _getbedtime(String? iD) async {
  CollectionReference _collectionRef =
      db.collection("Users").doc("$iD").collection("Bedtimes");
  // Get docs from collection reference
  QuerySnapshot querySnapshot = await _collectionRef
           .orderBy('time')
           .where("Active", isEqualTo: true) 
           .get();

  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

  return (allData);
}


Future<List<Object?>> _gettask(String? iD) async {
  CollectionReference _collectionRef =
      db.collection("Users").doc("$iD").collection("Tasks");
  // Get docs from collection reference
  QuerySnapshot querySnapshot = await _collectionRef.where('When', isGreaterThanOrEqualTo: _start) 
           .where('When', isLessThanOrEqualTo: _end)
           .orderBy('When')
           .get();

  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

  return (allData);
}



Future<Duration> _getUsageStats() async {
  List<AppUsageInfo> _infos = [];
  Duration combined = const Duration();
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




class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyStatefulWidgetsecond(),
    );
  }
}


class MyStatefulWidgetfirst extends StatefulWidget {
   MyStatefulWidgetfirst({Key? key}) : super(key: key);
  @override
  State<MyStatefulWidgetfirst> createState() => _MyStatefulWidgetStatefirst();
}

class MyStatefulWidgetsecond extends StatefulWidget {
   MyStatefulWidgetsecond({Key? key}) : super(key: key);
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
            context, MaterialPageRoute(builder: (context) => MyStatefulWidgetsecond())));
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

  bool _value = false;
  int _selectedIndex = 1;
  final pages = [
    const Sleeppage(),
    const MyHomePage(),
    const Sleeppage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void updatetask(String? iD,bool? value,String dic){
    db.collection('Users').doc("$iD").collection("Tasks").doc("$dic").update({'Done': value ?? false});

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
            canvasColor: Color.fromARGB(255, 230,230,250),
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: const TextStyle(color: Color.fromARGB(255, 158, 158, 158)))),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.call),
              label: 'Sleep',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Alarm',
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
                                        "Welcome back " + snapshots.data.toString(),
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
                    decoration: BoxDecoration(
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
                          Text(
                            'Upcoming Alarms',
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .02),
                          
                          Center(child: Text(
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
                    decoration: BoxDecoration(
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
                          Text(
                            'Upcoming Alarms',
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .02),
                          
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
                    decoration: BoxDecoration(
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
                          Text(
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
                    decoration: BoxDecoration(
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
                          Text(
                            'Upcoming Bedtime',
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .02),
                          
                          Center(child: Text(
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
                    decoration: BoxDecoration(
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
                          Text(
                            'Upcoming Bedtime',
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .02),
                          
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
                    decoration: BoxDecoration(
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
                          Text(
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
                                        style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ),
                ElevatedButton(
  onPressed: () {


showDialog(
  context: context,
  builder: (context) {
    DateTime _date = DateTime.now();
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
                    scrollable: true,
                    title: Text('Create Task'),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: namecontroller,
                              decoration: InputDecoration(
                                
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
                              decoration: InputDecoration(
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
                                labelText: DateFormat('MM/dd/yyyy - hh:mm a').format(_date),
                                icon: Icon(Icons.calendar_month),
                              ),
                            ),

                          
                            
                            ElevatedButton(
  onPressed: () {
    
    showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    title: Text('Pick Date'),
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
                    _date = newDateTime;
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
                          child: Text("Cencel"),
                          onPressed: () {
                            namecontroller.text = "";
                            descriptioncontroller.text = "";
                           Navigator.pop(context);
                          }),

                        ElevatedButton(
                          child: Text("Submit"),
                          onPressed: () {

                           createtask(inputData(),_date);
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
  child: Text('Create Task'),
  style: ElevatedButton.styleFrom(
    primary: const Color(0x218380), // Change color as need
    onPrimary: Colors.white, // Change text color as needed
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    minimumSize: Size(MediaQuery.of(context).size.width/2, 50), // Adjust size as needed
  ),
),

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
                      return CheckboxListTile(
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
                )

                        ])
                      
                      
                      )
              )
                      );
                      
                
  }
}
