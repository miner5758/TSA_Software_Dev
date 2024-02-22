import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:alarm/alarm.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

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
  QuerySnapshot querySnapshot = await _collectionRef.orderBy("time").get();

  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

  return (allData);
}

class Alarmpage extends StatelessWidget {
  const Alarmpage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyStatefulWidgetsecond(),
    );
  }
}


class MyStatefulWidgetsecond extends StatefulWidget {
   MyStatefulWidgetsecond({Key? key}) : super(key: key);
  @override
  State<MyStatefulWidgetsecond> createState() => _MyStatefulWidgetStatesecond();
}

class _MyStatefulWidgetStatesecond extends State<MyStatefulWidgetsecond>{
  void updateact(String? iD,bool value,String dic){
    db.collection('Users').doc("$iD").collection("Alarms").doc("$dic").update({'Active': value});
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
                              height: MediaQuery.of(context).size.height * .05),
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
                            return ListView.builder(
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
                        leading: Icon(Icons.alarm),
                        title: Text(lnapshots.data[index]["Name"].toString()),
                        subtitle: Text('L'),
                    ),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Switch(value: lnapshots.data[index]["Active"], onChanged: (bool value){
                         updateact(inputData(),value,lnapshots.data[index]["Name"].toString());
                         setState(() {
                           
                         });
                        })
                      ],
                    ),
                  ],)
                  
                  );
                            }
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

              ElevatedButton(
                onPressed: () {
                

              }, child: Text("create"))
          ]),
      ),
      )
    );
  }

  
}


