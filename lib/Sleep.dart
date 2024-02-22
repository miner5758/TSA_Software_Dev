import 'package:flutter/material.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';




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

Future<List<Object?>> _gettata(String? iD) async {
  
  CollectionReference _collectionRef =
      db.collection("Users").doc("$iD").collection("Tracking");
  // Get docs from collection reference
  QuerySnapshot querySnapshot = await _collectionRef.orderBy("Start").get();

  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList().reversed;

  return (List.from(allData));
}

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
  String _pag = "";

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

String musicUrl = "https://cdn.pixabay.com/audio/2024/02/14/audio_b9bc3934cc.mp3";
String thumbnailImgUrl = "https://images.squarespace-cdn.com/content/v1/5fa5ec79661ee904d2973ca0/1608218991352-VVQ4O65NM06XBN9F01ML/relaxing_photo_1.jpg"; // Insert your thumbnail URL 
var player = AudioPlayer(); 
bool loaded = false; 
bool playing = false; 


void createbedtime(String? iD,DateTime date){
  
    db.collection('Users').doc("$iD").collection("Bedtimes").doc("bedtime 1").set(
      {
        "Active":true,
        
        "time":Timestamp.fromDate(date),
        }
        );

}
 
void loadMusic() async { 
  await player.setUrl(musicUrl); 
  setState(() { 
    loaded = true; 
  }); 
} 
 
void playMusic() async { 
  setState(() { 
    playing = true; 
  }); 
  await player.play(); 
} 
 
void pauseMusic() async { 
  setState(() { 
    playing = false; 
  }); 
  await player.pause(); 
} 
 
 
@override 
void dispose() { 
  player.dispose(); 
  super.dispose(); 
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
        panel: 
       Center(
        child: Builder(
        builder: (context) {
          if (_pag == "tracking"){
            return Container(
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
                width: MediaQuery.of(context).size.width * .55),
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
        ); 
          } else if(_pag == "playlist"){
            return Container(
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
        Column( 
          children: [
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
                                        "Playlist",
                                        style:  TextStyle(
                                            fontSize: MediaQuery.of(context).size.height * .03,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ),

              const Spacer( 
            flex: 2, 
          ), 
          ClipRRect( 
            borderRadius: BorderRadius.circular(8), 
            child: Image.network( 
              thumbnailImgUrl, 
              height: 350, 
              width: 350, 
              fit: BoxFit.cover, 
            ), 
          ), 
          const Spacer(), 
          Padding( 
            padding: const EdgeInsets.symmetric(horizontal: 8), 
            child: 
            StreamBuilder( 
                stream: player.positionStream, 
                builder: (context, snapshot1) { 
                  final Duration duration = loaded 
                      ? snapshot1.data as Duration 
                      : const Duration(seconds: 0); 
                  return StreamBuilder( 
                      stream: player.bufferedPositionStream, 
                      builder: (context, snapshot2) { 
                        final Duration bufferedDuration = loaded 
                            ? snapshot2.data as Duration 
                            : const Duration(seconds: 0); 
                        return SizedBox( 
                          height: 30, 
                          child: Padding( 
                            padding: const EdgeInsets.symmetric(horizontal: 16), 
                            child: ProgressBar( 
                              progress: duration, 
                              total: 
                                  player.duration ?? const Duration(seconds: 0), 
                              buffered: bufferedDuration, 
                              timeLabelPadding: -1, 
                              timeLabelTextStyle: const TextStyle( 
                                  fontSize: 14, color: Colors.black), 
                              progressBarColor: Colors.red, 
                              baseBarColor: Colors.grey[200], 
                              bufferedBarColor: Colors.grey[350], 
                              thumbColor: Colors.red, 
                              onSeek: loaded 
                                  ? (duration) async { 
                                      await player.seek(duration); 
                                    } 
                                  : null, 
                            ), 
                          ), 
                        ); 
                      }); 
                }), 
          ),
 
          const SizedBox( 
            height: 8, 
          ), 
          Row( 
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
            children: [ 
              const SizedBox( 
                width: 10, 
              ), 
              IconButton( 
                  onPressed: loaded 
                      ? () async { 
                          if (player.position.inSeconds >= 10) { 
                            await player.seek(Duration( 
                                seconds: player.position.inSeconds - 10)); 
                          } else { 
                            await player.seek(const Duration(seconds: 0)); 
                          } 
                        } 
                      : null, 
                  icon: const Icon(Icons.fast_rewind_rounded)), 
              Container( 
                height: 50, 
                width: 50, 
                decoration: const BoxDecoration( 
                    shape: BoxShape.circle, color: Colors.red), 
                child: IconButton( 
                    onPressed: loaded 
                        ? () { 
                            if (playing) { 
                              pauseMusic(); 
                            } else { 
                              playMusic(); 
                            } 
                          } 
                        : null, 
                    icon: Icon( 
                      playing ? Icons.pause : Icons.play_arrow, 
                      color: Colors.white, 
                    )), 
              ), 
              IconButton( 
                  onPressed: loaded 
                      ? () async { 
                          if (player.position.inSeconds + 10 <= 
                              player.duration!.inSeconds) { 
                            await player.seek(Duration( 
                                seconds: player.position.inSeconds + 10)); 
                          } else { 
                            await player.seek(const Duration(seconds: 0)); 
                          } 
                        } 
                      : null, 
                  icon: const Icon(Icons.fast_forward_rounded)), 
              const SizedBox( 
                width: 10, 
              ), 
            ], 
          ), 
          const Spacer( 
            flex: 2, 
          ) 
        ], 
      
                
            ),
        );
          }else if(_pag == "history"){
            return Container(
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
                                        "Sleep History",
                                        style:  TextStyle(
                                            fontSize: MediaQuery.of(context).size.height * .03,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ),
SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                                     FutureBuilder(
                      future: _gettata(inputData()),
                      builder: (context, AsyncSnapshot lnapshots){
                        if(lnapshots.hasData){
                          if (lnapshots.data.length == 0){
                            return Text("No Data");
                          }  else{
                            return Expanded(child: ListView.builder(
                            padding: EdgeInsets.zero,
                            reverse: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: lnapshots.data.length,
                            itemBuilder: (context, index){
                              return SizedBox(child: Card(
                                child: ExpansionTile(
                                title: Text("Your sleep on " + formatTimestampdate(lnapshots.data[index]["Start"]).toString()),
                                children: <Widget> [
                                  Column(children: [
                                    Center(child: ListTile(
                                trailing:
                                  Icon(Icons.punch_clock_rounded),
                                  title: Text("Start: " + formatTimestamptime(lnapshots.data[index]["Start"]).toString()),

                              ),),
                              Center(child: ListTile(
                                trailing:
                                  Icon(Icons.bed_outlined),
                                  title: Text("Duration: " + lnapshots.data[index]["Length"].toString()),

                              ),)
                                  ],)
                                ],
                            )
                              ),);
                              
                              
                            }
                            )
                            );
                          }
                        } else if (lnapshots.hasError){
                          return Text("${lnapshots.hasError}");
                        }
                        return const CircularProgressIndicator();
                      }
                  ),
          ],)
            );
          } else{
            return Container(
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
        );
          }

          
        },
      ),
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
                              image: AssetImage('lib/images/back.jpg'),
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
                                           color: Colors.black,
                                            fontSize: MediaQuery.of(context).size.height * .022,
                                            fontWeight: FontWeight.bold,),
                                            textAlign: TextAlign.center,
                                            
                                      ),
                                      ),),
                                      
                          Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.04),
                                child: Center(child:Text(
                                        "10 to 14 hours of sleep",
                                        style:  TextStyle(
                                           color: Colors.black,
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
                              image: AssetImage('lib/images/back.jpg'),
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
                                           color: Colors.black,
                                            fontSize: MediaQuery.of(context).size.height * .022,
                                            fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                      ),
                                      ),),
                                      
                          Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.04),
                                child: Center(child:Text(
                                        "9 to 11 hours of sleep",
                                        style:  TextStyle(
                                           color: Colors.black,
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
                              image: AssetImage('lib/images/back.jpg'),
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
                                           color: Colors.black,
                                            fontSize: MediaQuery.of(context).size.height * .022,
                                            fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                      ),
                                      ),),
                                      
                          Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.04),
                                child: Center(child:Text(
                                        "8 to 10 hours of sleep",
                                        style:  TextStyle(
                                           color: Colors.black,
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
                              image: AssetImage('lib/images/back.jpg'),
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
                                           color: Colors.black,
                                            fontSize: MediaQuery.of(context).size.height * .022,
                                            fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                      ),
                                      ),),
                                      
                          Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.04),
                                child: Center(child:Text(
                                        "7 to 9 hours of sleep",
                                        style:  TextStyle(
                                           color: Colors.black,
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
                              image: AssetImage('lib/images/back.jpg'),
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
                                           color: Colors.black,
                                            fontSize: MediaQuery.of(context).size.height * .022,
                                            fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                      ),
                                      ),),
                                      
                          Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.04),
                                child: Center(child:Text(
                                        "7 to 8 hours of sleep",
                                        style:  TextStyle(
                                           color: Colors.black,
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
                              _pag = "tracking";
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
                              _pag = "playlist";
                              showDialog(
  context: context,
  builder: (context){
    return AlertDialog(
      scrollable: true,
                    title: Text('Pick Song'),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        ElevatedButton(onPressed: (){
                          
                          setState(() {
                            musicUrl = "https://cdn.pixabay.com/audio/2024/02/14/audio_b9bc3934cc.mp3";
                            loadMusic();
                          });
                          loaded = false; 
                          playing = false; 
                          Navigator.pop(context);
                          _pc1.open();
                        }, child: const Text('One')),
                        ElevatedButton(onPressed: (){
                          
                          setState(() {
                            musicUrl = "https://cdn.pixabay.com/audio/2024/01/23/audio_eec3a6aae5.mp3";
                            loadMusic();
                          });
                          loaded = false; 
                          playing = false;
                          Navigator.pop(context);
                          _pc1.open();
                        }, child: const Text('two')),
                        ElevatedButton(onPressed: (){
                          
                          setState(() {
                            musicUrl = "https://cdn.pixabay.com/audio/2023/01/29/audio_580d2c877d.mp3";
                            loadMusic();
                          });
                          loaded = false; 
                          playing = false;
                          Navigator.pop(context);
                          _pc1.open();
                        }, child: const Text('three')),
                        ElevatedButton(onPressed: (){
                         
                          setState(() {
                            musicUrl = "https://cdn.pixabay.com/audio/2024/02/08/audio_63e77cccc2.mp3";
                            loadMusic();
                          });
                          loaded = false; 
                          playing = false;
                          Navigator.pop(context);
                          _pc1.open();
                        }, child: const Text('four')),
                        ElevatedButton(onPressed: (){
                          
                          setState(() {
                            musicUrl = "https://cdn.pixabay.com/audio/2024/01/09/audio_3311c4e7b3.mp3";
                            loadMusic();
                          });
                          loaded = false; 
                          playing = false;
                          Navigator.pop(context);
                          _pc1.open();
                        }, child: const Text('five')),
                        ElevatedButton(onPressed: (){
                          
                          setState(() {
                            musicUrl = "https://cdn.pixabay.com/audio/2024/01/16/audio_9fc2c1b277.mp3";
                            loadMusic();
                          });
                          loaded = false; 
                          playing = false;
                          Navigator.pop(context);
                          _pc1.open();
                        }, child: const Text('six')),
                      ],)
    ));
  }
                              );
                              
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
                                 showDialog(
                context: context,
                builder: (BuildContext context) {
                  DateTime _date = DateTime.now();
                  return AlertDialog(
                    scrollable: true,
                    title: Text('Pick Date'),
                    content: 
                    Padding(
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
                    ),
                    actions: [
                      ElevatedButton(
                          child: Text("Cencel"),
                          onPressed: () {
                            _date = DateTime.now();
                           Navigator.pop(context);
                          }),

                          ElevatedButton(
                          child: Text("Submit"),
                          onPressed: () {

                           createbedtime(inputData(),_date);
                           Navigator.pop(context);
                           _date = DateTime.now();
                           
                          }),
                    ],
                  );
  });
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
                              _pag = "history";
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