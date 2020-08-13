import 'dart:math';
import 'package:flutter/material.dart';
import 'GameScreen.dart';
import 'LoadScreen.dart';
import 'HomeScreen.dart';
import "MazosScreen.dart";
import 'MazoEditScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trago o consecuencia',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: TragoConsecuenciaJuego(),
      home: LoadScreen(),
      //home: HomeScreen(),
      //home: MazosScreen(),
      //home: MazoEditScreen(),
      routes: {
        LoadScreen.route : (context) => LoadScreen(),
        GameScreen.route : (context) => GameScreen(),
        HomeScreen.route : (context) => HomeScreen(),
        MazosScreen.route : (context) => MazosScreen(),
        MazoEditScreen.route : (context) => MazoEditScreen(),
      },
    );
  }
}

