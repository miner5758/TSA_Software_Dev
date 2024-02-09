import 'package:flutter/material.dart'; 
import 'dart:async'; 

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
 
  @override 
  _MyHomePageState createState() => _MyHomePageState(); 
} 
class _MyHomePageState extends State<MyHomePage> { 
  @override 
  void initState() { 
    super.initState(); 
    Timer(const Duration(seconds: 3), 
          ()=>Navigator.pushReplacement(context, 
                                        MaterialPageRoute(builder: 
                                                          (context) =>  
                                                          SecondScreen() 
                                                         ) 
                                       ) 
         ); 
  } 
  @override 
  Widget build(BuildContext context) { 
    return Container( 
      color: Colors.white, 
      child:FlutterLogo(size:MediaQuery.of(context).size.height) 
    ); 
  } 
} 
class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar(title:const Text("GeeksForGeeks")), 
      body: const Center( 
        child:Text("Home page",) 
      ), 
    ); 
  } 
} 