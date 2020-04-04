import 'package:Swapp/pages/global_infos.dart';
import 'package:Swapp/pages/profile_page.dart';
import 'package:flutter/material.dart';

class MyAppBar {
  setAppBar(context, String title, {Function loginCallBack,bool withInfo = true}) {
    return new AppBar(
      title: Center(
        child: Text(title, textAlign: TextAlign.center),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor
            ])),
      ),
      actions: <Widget>[
        _profilButtonAppBarComponent(context, loginCallBack),
        _infosButtonsComponent(context,withInfo),

      ],
    );
  }

  Widget _profilButtonAppBarComponent(context, loginCallBack) {
    if (loginCallBack !=null)
      return Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePage(loginCallBack)),
            );
          },
          child: Icon(Icons.person),
        ),
      );
//si loginCallback est null
    return Container(
      width: 0,
      height: 0,
    );
  }

  Widget _infosButtonsComponent(context,bool withInfo) {
    if (withInfo){
      return         Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InfosGeneral()),
            );
          },
          child: Icon(Icons.info_outline),
        ),
      );
    }
      else {
    return Container(width: 0,height: 0,);
    }

  }
}
