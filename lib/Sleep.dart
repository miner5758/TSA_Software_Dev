import 'package:flutter/material.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


final FirebaseAuth auth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;


String? inputData() {
  final User? user = auth.currentUser;
  final uid = user?.uid;
  return uid;
}

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
 late Stopwatch stopwatch;
  late Timer t;
  DateTime _now = DateTime(2024);
  bool fir = true;

  void record(String? iD,String time){
  var uuid = const Uuid();
    db.collection('Users').doc("$iD").collection("Tracking").doc(uuid.v1()).set(
      {
        "Start":Timestamp.fromDate(_now),
        "Length":time,
        }
        );

}
 
  void handleStartStop() {
    if(stopwatch.isRunning) {
      stopwatch.stop();
    }
    else {
      stopwatch.start();
      if(fir){
        _now = DateTime.now();
        fir = false;
      }
    }
  }
 
  String returnFormattedText() {
  var milli = stopwatch.elapsed.inMilliseconds;

  String milliseconds = (milli % 1000).toString().padLeft(3, "0");
  String seconds = ((milli ~/ 1000) % 60).toString().padLeft(2, "0");
  String minutes = ((milli ~/ 1000) ~/ 60).toString().padLeft(2, "0");

  // Calculate hours
  int hours = ((milli ~/ 1000) ~/ 60) ~/ 60;  // Hours from elapsed milliseconds
  String hoursStr = hours.toString().padLeft(2, "0");  // Pad with leading zeros

  return "$hoursStr:$minutes:$seconds:$milliseconds";  // Concatenate with hours
}
 
  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch();
  
 
    t = Timer.periodic(Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }
  bool _visible = true;
  final PanelController _pc1 = PanelController();
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Visibility(
        maintainState: true,
        maintainAnimation: true,
        visible: _visible,
        child: SlidingUpPanel(
          controller: _pc1,
          isDraggable: false,
          minHeight: MediaQuery.of(context).size.height * 0,
          maxHeight: MediaQuery.of(context).size.height * .95,
      
        panel: Container(
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
                  child:
        Column( children: [
          SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.88,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.10,
                      foregroundDecoration: BoxDecoration(
                        border: Border.all(
                          width: 5,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                          splashColor: Colors.blue,
                          onTap: () {
                            _pc1.close();
                          },
                          child: const FittedBox(
                              child: Icon(
                                Icons.close,
                              ),
                              fit: BoxFit.fill)),
                    ),
                  ],
                ),
                Center(child:Text(
                                        "Sleep Tracker",
                                        style:  TextStyle(
                                            fontSize: MediaQuery.of(context).size.height * .03,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ),
        SafeArea(
        child: Center(
          child: Column( // this is the column
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
 
              ElevatedButton(
                onPressed: () {
                  handleStartStop();
                },
                 style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                
                child: Container(
                  height: MediaQuery.of(context).size.height * .30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,  // this one is use for make the circle on ui.
                    border: Border.all(
                      color: Color.fromARGB(255, 235, 77, 3),
                      width: MediaQuery.of(context).size.height * .005,
                    ),
                  ),
                  child: Text(returnFormattedText(), style: TextStyle(
                    color: Colors.black,
                    
                    fontSize: MediaQuery.of(context).size.height * .046,
                    fontWeight: FontWeight.bold,
                  ),),
                ),
              ),
 
              SizedBox(height: MediaQuery.of(context).size.height * .02,),

              Row(children: [
              ElevatedButton(     // this the cupertino button and here we perform all the reset button function
                onPressed: () {
                  fir = true;
                  stopwatch.reset();
                },
                child: Text("Reset", style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),),
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width * .565),
              ElevatedButton(     // this the cupertino button and here we perform all the reset button function
                onPressed: () {
                  record(inputData(), returnFormattedText());
                  fir = true;
                  stopwatch.reset();
                },
                
                child: Text("Record", style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),),
              ),
              ],)
            ],
          ),
        
        ),
      ),
        ]),
        ),
      body:
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
                      FutureBuilder(future:  db.collection("Users").doc(inputData()).get().then((value) {
          return value.data()!["Age"];
        }), builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            int age = int.parse(snapshot.data.toString());
            if(age >= 2 && age <= 5){
              return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.32,
                      child: Stack(
                        children: [
                          Container(
                            height: (MediaQuery.of(context).size.height * 0.32),
                            width: (MediaQuery.of(context).size.width),
                            foregroundDecoration: const BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage('lib/images/blu.jpg'),
                              fit: BoxFit.fill,
                            )),
                          ),
                          Column(
                            children: [
                           Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.1),
                                child: Center(child:Text(
                                        "The average ${snapshot.data.toString()} year old must get around",
                                        style:  TextStyle(
                                           color: Colors.white,
                                            fontSize: MediaQuery.of(context).size.height * .022,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ),),
                                      
                          Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.04),
                                child: Center(child:Text(
                                        "10 to 14 hours of sleep",
                                        style:  TextStyle(
                                           color: Colors.white,
                                            fontSize: MediaQuery.of(context).size.height * .03,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ),)
                            ]
                          )
                    ])
            );
            } else if(age > 5 && age <= 12){
              return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.32,
                      child: Stack(
                        children: [
                          Container(
                            height: (MediaQuery.of(context).size.height * 0.32),
                            width: (MediaQuery.of(context).size.width),
                            foregroundDecoration: const BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage('lib/images/blu.jpg'),
                              fit: BoxFit.fill,
                            )),
                          ),
                          Column(
                            children: [
                           Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.1),
                                child: Center(child:Text(
                                        "The average ${snapshot.data.toString()} year old must get around",
                                        style:  TextStyle(
                                           color: Colors.white,
                                            fontSize: MediaQuery.of(context).size.height * .022,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ),),
                                      
                          Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.04),
                                child: Center(child:Text(
                                        "9 to 11 hours of sleep",
                                        style:  TextStyle(
                                           color: Colors.white,
                                            fontSize: MediaQuery.of(context).size.height * .03,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ),)
                            ]
                          )
                    ])
            );
            } else if(age>12 && age <= 18){
              return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.32,
                      child: Stack(
                        children: [
                          Container(
                            height: (MediaQuery.of(context).size.height * 0.32),
                            width: (MediaQuery.of(context).size.width),
                            foregroundDecoration: const BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage('lib/images/blu.jpg'),
                              fit: BoxFit.fill,
                            )),
                          ),
                          Column(
                            children: [
                           Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.1),
                                child: Center(child:Text(
                                        "The average ${snapshot.data.toString()} year old must get around",
                                        style:  TextStyle(
                                           color: Colors.white,
                                            fontSize: MediaQuery.of(context).size.height * .022,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ),),
                                      
                          Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.04),
                                child: Center(child:Text(
                                        "8 to 10 hours of sleep",
                                        style:  TextStyle(
                                           color: Colors.white,
                                            fontSize: MediaQuery.of(context).size.height * .03,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ),)
                            ]
                          )
                    ])
            );
            } else if(age>18 && age <= 65){
              return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.32,
                      child: Stack(
                        children: [
                          Container(
                            height: (MediaQuery.of(context).size.height * 0.32),
                            width: (MediaQuery.of(context).size.width),
                            foregroundDecoration: const BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage('lib/images/blu.jpg'),
                              fit: BoxFit.fill,
                            )),
                          ),
                          Column(
                            children: [
                           Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.1),
                                child: Center(child:Text(
                                        "The average ${snapshot.data.toString()} year old must get around",
                                        style:  TextStyle(
                                           color: Colors.white,
                                            fontSize: MediaQuery.of(context).size.height * .022,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ),),
                                      
                          Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.04),
                                child: Center(child:Text(
                                        "7 to 9 hours of sleep",
                                        style:  TextStyle(
                                           color: Colors.white,
                                            fontSize: MediaQuery.of(context).size.height * .03,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ),)
                            ]
                          )
                    ])
            );
            } else{
              return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.32,
                      child: Stack(
                        children: [
                          Container(
                            height: (MediaQuery.of(context).size.height * 0.32),
                            width: (MediaQuery.of(context).size.width),
                            foregroundDecoration: const BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage('lib/images/blu.jpg'),
                              fit: BoxFit.fill,
                            )),
                          ),
                          Column(
                            children: [
                           Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.1),
                                child: Center(child:Text(
                                        "The average ${snapshot.data.toString()} year old must get around",
                                        style:  TextStyle(
                                           color: Colors.white,
                                            fontSize: MediaQuery.of(context).size.height * .022,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ),),
                                      
                          Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.04),
                                child: Center(child:Text(
                                        "7 to 8 hours of sleep",
                                        style:  TextStyle(
                                           color: Colors.white,
                                            fontSize: MediaQuery.of(context).size.height * .03,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ),)
                            ]
                          )
                    ])
            );
            }
            
          } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return const CircularProgressIndicator();
        }),
        SizedBox(
                              height: MediaQuery.of(context).size.height * .05),
Align( //The align widget
            alignment : Alignment.topRight, 
            child: Container(
          alignment: Alignment.topRight,
          height: MediaQuery.of(context).size.height * .08,
          width: MediaQuery.of(context).size.width * .7,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(50.0),
            ),
          ),
          child:  Material(
  color: Colors.white,
  borderRadius: BorderRadius.horizontal(
              left: Radius.circular(50.0),
            ), child: InkWell(
          splashColor: Colors.blue,
                                onTap: () {
                                  _visible = true;
                              setState(() {});
                              _pc1.open();
                                  },
                                child: Center(child:Text(
                                        "Sleep Tracker",
                                        style:  TextStyle(
                                            fontSize: MediaQuery.of(context).size.height * .03,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ),
        
          )
          )
        )
),


              SizedBox(
                height: MediaQuery.of(context).size.height * .05),
              
              Align( //The align widget
            alignment : Alignment.topLeft, 
            child: Container(
          alignment: Alignment.topLeft,
          height: MediaQuery.of(context).size.height * .08,
          width: MediaQuery.of(context).size.width * .7,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.horizontal(
              right: Radius.circular(50.0),
            ),
          ),
          child:  Material(
  color: Colors.white,
  borderRadius: BorderRadius.horizontal(
              right: Radius.circular(50.0),
            ), child: InkWell(
          splashColor: Colors.blue,
                                onTap: () {
                                  _visible = true;
                              setState(() {});
                              _pc1.open();
                                  },
                                child: Center(child:Text(
                                        "Sleep Soundtracks",
                                        style:  TextStyle(
                                            fontSize: MediaQuery.of(context).size.height * .03,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ),
        
          )
          )
        )
),

 SizedBox(
                height: MediaQuery.of(context).size.height * .05),

Align( //The align widget
            alignment : Alignment.topRight, 
            child: Container(
          alignment: Alignment.topRight,
          height: MediaQuery.of(context).size.height * .08,
          width: MediaQuery.of(context).size.width * .7,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(50.0),
            ),
          ),
          child:  Material(
  color: Colors.white,
  borderRadius: BorderRadius.horizontal(
              left: Radius.circular(50.0),
            ), child: InkWell(
          splashColor: Colors.blue,
                                onTap: () {
                                  _visible = true;
                              setState(() {});
                              _pc1.open();
                                  },
                                child: Center(child:Text(
                                        "Set Bedtime",
                                        style:  TextStyle(
                                            fontSize: MediaQuery.of(context).size.height * .03,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ),
        
          )
          )
        )
),

SizedBox(
                height: MediaQuery.of(context).size.height * .05),
              
              Align( //The align widget
            alignment : Alignment.topLeft, 
            child: Container(
          alignment: Alignment.topLeft,
          height: MediaQuery.of(context).size.height * .08,
          width: MediaQuery.of(context).size.width * .7,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.horizontal(
              right: Radius.circular(50.0),
            ),
          ),
          child:  Material(
  color: Colors.white,
  borderRadius: BorderRadius.horizontal(
              right: Radius.circular(50.0),
            ), child: InkWell(
          splashColor: Colors.blue,
                                onTap: () {
                                  _visible = true;
                              setState(() {});
                              _pc1.open();
                                  },
                                child: Center(child:Text(
                                        "Sleep History",
                                        style:  TextStyle(
                                            fontSize: MediaQuery.of(context).size.height * .03,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ),
        
          )
          )
        )
),
                      
                        
                      
                    ],
                  )
      )
      )
      )
    );
  }
}