import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hold_app/pages/GroceriesShoppingPage.dart';

import '../ProfilePage.dart';

class MyContainerPage extends StatefulWidget {

  MyContainerPage(this.firestore, this.logoutCallback) :
   _widgetOptions = <Widget>[
      ProfilePage(logoutCallback),
      GroceriesShoppingPage(),
      Text(
        'Mes missions',
        style: MyContainerPage.optionStyle,
      ),
    ];

  final Function logoutCallback;
  final Firestore firestore;
  final List<Widget> _widgetOptions;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);




  @override
  _MyContainerPageState createState() => _MyContainerPageState();
}

class _MyContainerPageState extends State<MyContainerPage> {

int _selectedIndex = 1;

void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: widget._widgetOptions.elementAt(_selectedIndex),
    ),
    bottomNavigationBar: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Mon profil'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.view_list),
          title: Text('Missions'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          title: Text('Mes activités'),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Theme.of(context).primaryColor,
      onTap: _onItemTapped,
    ),
  );
}
}