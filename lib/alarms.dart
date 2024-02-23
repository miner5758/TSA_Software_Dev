// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter/cupertino.dart';
import 'package:sleep_application/home.dart';
import 'dart:math';




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
  QuerySnapshot querySnapshot = await collectionRef.orderBy("time").get();

  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

  return (allData);
}



class Alarmpage extends StatelessWidget {
  const Alarmpage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MyStatefulWidgetsecond(),
    );
  }
}


class MyStatefulWidgetsecond extends StatefulWidget {
   const MyStatefulWidgetsecond({super.key});
  @override
  State<MyStatefulWidgetsecond> createState() => _MyStatefulWidgetStatesecond();
  
}

class _MyStatefulWidgetStatesecond extends State<MyStatefulWidgetsecond>{
  TextEditingController namecontroller = TextEditingController();
TextEditingController descriptioncontroller = TextEditingController();
  void updateact(String? iD,bool value,String dic){
    db.collection('Users').doc("$iD").collection("Alarms").doc(dic).update({'Active': value});
}
void createtask(String? iD,DateTime date,number){
  
  
    db.collection('Users').doc("$iD").collection("Alarms").doc(namecontroller.text).set(
      {
        "Active":true,
        "Des":descriptioncontroller.text,
        "Name":namecontroller.text,
        "time":Timestamp.fromDate(date),
        "id" : number
        }
        );

}

  Future<void> set(var here) async {
    await Alarm.init();
    await Alarm.set(alarmSettings: here);

  }
@override
  void initState() {
    
    super.initState();
  }


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
child:
     Container(
                  decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                 Color(0xFF3366FF),
                   Color(0xFF00CCFF),
                ],
                begin:  FractionalOffset(0.0, 0.0),
                end:  FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Column(children: [
            SizedBox(
                              height: MediaQuery.of(context).size.height * .10),
            Center(child:Text(
                                        "Your Alarms",
                                        style:  TextStyle(
                                            fontSize: MediaQuery.of(context).size.height * .03,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ),
                                      SizedBox(
                              height: MediaQuery.of(context).size.height * .01),
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
                    title: const Text('Create Alarm'),
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
                          onPressed: () async {
                          Random random = Random();
int randomNumber = random.nextInt(10000);
                            await Alarm.init();
final alarmSettings = AlarmSettings(
  id: randomNumber,
  dateTime: date,
  assetAudioPath: 'lib/images/alarm.mp3',
  loopAudio: true,
  vibrate: true,
  volume: 0.8,
  fadeDuration: 3.0,
  notificationTitle: namecontroller.text,
  notificationBody: descriptioncontroller.text,
  enableNotificationOnKill: true,
);
await Alarm.set(alarmSettings: alarmSettings);

                           createtask(inputData(),date,randomNumber);
                           Navigator.pop(context);
                           namecontroller.text = "";
                            descriptioncontroller.text = "";
                            
                           Navigator.pop(context);  // pop current page
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyHomePage()));

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
                              height: MediaQuery.of(context).size.height * .03),
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
                            return Expanded( child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: lnapshots.data.length,
                            itemBuilder: (context, index){
                              return Card(child:
                  Column(
                     mainAxisSize: MainAxisSize.min,
                    children: [
                      
ListTile(
                        leading: const Icon(Icons.alarm),
                        title: Text(lnapshots.data[index]["Name"].toString()),
                        subtitle: Text(lnapshots.data[index]["Des"].toString()),
                    ),
                    
                    
                    Text( "${DateFormat('EEEE').format(lnapshots.data[index]["time"].toDate())} at ${formatTimestamptime(lnapshots.data[index]["time"])}"
                      ),

                     Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Switch(value: lnapshots.data[index]["Active"], onChanged: (bool value) async{
                         updateact(inputData(),value,lnapshots.data[index]["Name"].toString());
                         await Alarm.init();
                         if(!value){
                         Alarm.stop(lnapshots.data[index]["id"]);
                         } else{
                          final alarmSettings = AlarmSettings(
  id: lnapshots.data[index]["id"],
  dateTime: lnapshots.data[index]["time"].toDate(),
  assetAudioPath: 'lib/images/alarm.mp3',
  loopAudio: true,
  vibrate: true,
  volume: 0.8,
  fadeDuration: 3.0,
  notificationTitle: 'This is the title',
  notificationBody: 'This is the body',
  enableNotificationOnKill: true,
);
await Alarm.set(alarmSettings: alarmSettings);
                         }
                         setState(() {
                           
                         });
                        })
                      ],
                    ),
                    
                  ],)
                  
                  );
                            }
                            )
                          );
                          }
                      } else if (lnapshots.hasError) {
                        // ignore: avoid_print
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
                            
              
              
          ]),
      ),
      )
    );
  }

  
}


