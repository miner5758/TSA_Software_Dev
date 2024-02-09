import 'package:flutter/material.dart';

import 'home.dart'; 
void main() { 
  runApp(MyApp()); 
} 
  
class MyApp extends StatelessWidget { 
  @override 
  Widget build(BuildContext context) { 
    return MaterialApp( 
      title: 'Splash Screen', 
      theme: ThemeData( 
        primarySwatch: Colors.green, 
      ), 
      home: const MyHomePage(), 
      debugShowCheckedModeBanner: false, 
    ); 
  } 
} 
  