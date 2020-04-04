import 'package:Swapp/pages/root_page.dart';
import 'package:Swapp/services/authentification.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Swa\'App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.teal[400],
          accentColor: Colors.lightBlue[700],

          fontFamily: 'Robotto',
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal),
            title: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
            body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ),
        home: new RootPage(auth: new Auth()));
  }
}
