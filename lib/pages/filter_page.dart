import 'package:Swapp/pages/call_page.dart';
import 'package:Swapp/services/authentification.dart';
import 'package:Swapp/widget/ReusableAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'VideoPage2.dart';

class FilterPage extends StatefulWidget {
  final BaseAuth auth = new Auth();
  final Firestore firestore;
  final Function logoutCallback;

  FilterPage(this.firestore, this.logoutCallback);
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String _errorMessage;

  @override
  void initState() {
    super.initState();
    _errorMessage = "";
  }
  /*
      return new Scaffold(
        appBar: MyAppBar().setAppBar(context, "Sw'app"),
        body: Stack(
          children: <Widget>[
            _showForm(),
            _showCircularProgress(),
            getOverlayWidget()
          ],
        ));
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar().setAppBar(context, "Sw'app"),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          Container(height: 20),
          _showTitle(),
          Container(height: 20),
          _showMeetingTypes(),
          showPrimaryButton(),
          showErrorMessage(),
        ],
      ),
    );
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text('Let\'s Go'),
            onPressed: validateAndSubmit,
          ),
        ));
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Future<void> validateAndSubmit() async {
    // service: get channel from filter...
    // search on all searching list... if nothing => add entry....
    await _handleCameraAndMic();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CallPage(appId: APP_ID, channelName: "onlyOneChannel")));
  }


  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }

  Widget _showMeetingTypes() {
    return ListView(
      children: <Widget>[
        Text('Type of meeting',
        style: TextStyle(
        fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        ),
        Text('j\'aimeles pates',
        style: TextStyle(
        fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        ),
      ],
    );
  }

  Widget _showTitle() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Let\'s meet ',
        style: TextStyle(
          fontSize: 30,
          color: Colors.black,
          fontStyle: FontStyle.italic,
        ),
        children: <TextSpan>[
          TextSpan(text: 'people !',
              style: TextStyle(fontWeight: FontWeight.bold)
          ),
        ],
      ),
    );
  }
}


