import 'package:Swapp/pages/global_infos.dart';
import 'package:flutter/material.dart';
class MyAppBar {
  setAppBar(context, String title) {
    return new AppBar(
      title: Center(child : Text(title, textAlign: TextAlign.center),),

      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Theme.of(context).accentColor, Theme.of(context).primaryColor])),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child : GestureDetector(
            onTap:(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InfosGeneral()),
              );
            } ,
            child: Icon(Icons.info_outline),
          ),
        ),
      ],
    );
  }
}