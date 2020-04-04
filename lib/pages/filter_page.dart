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
  bool _isRandomSelected;
  bool _isDiscussion;
  bool _isEntertainement;
  bool _isLanguageTraining;
  bool _isCultural;
  bool _isParty;

  @override
  void initState() {
    _isRandomSelected = true;
    _isDiscussion = false;
    _isEntertainement = false;
    _isLanguageTraining = false;
    _isCultural = false;
    _isParty = false;
    _errorMessage = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar().setAppBar(context, "Sw'app",
      loginCallBack: widget.logoutCallback),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          Container(height: 20),
          _showTitle(),
          Container(height: 20),
          Text(
            'Type of meeting',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(height: 20),
          FilterChip(
            selectedColor: Colors.blue,
            selected: _isRandomSelected,
            label: Text('Random',
                style: TextStyle(
                fontSize: 20
            ),
          ),
            onSelected: (bool value) {
              setState(() {
                _isRandomSelected = !_isRandomSelected;
              });
            },
          ),
          new CheckboxListTile(
            title: Text("Discussion"),
            value: _isDiscussion,
            onChanged: (bool value) {
              setState(() {
                _isDiscussion = !_isDiscussion;
              });
            },
          ),
          new CheckboxListTile(
            title: Text("Entertainement"),
            value: _isEntertainement,
            onChanged: (bool value) {
              setState(() {
                _isEntertainement = !_isEntertainement;
              });
            },
          ),
          new CheckboxListTile(
            title: Text("Cultural"),
            value: _isCultural,
            onChanged: (bool value) {
              setState(() {
                _isCultural = !_isCultural;
              });
            },
          ),
          new CheckboxListTile(
            title: Text("Party"),
            value: _isParty,
            onChanged: (bool value) {
              setState(() {
                _isParty = !_isParty;
              });
            },
          ),
          new CheckboxListTile(
            title: Text("Language training",),
            value: _isLanguageTraining,
            onChanged: (bool value) {
              setState(() {
                _isLanguageTraining = !_isLanguageTraining;
              });
            },
          ),
          Text(
            'Filter',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(height: 10),
          _filterRow('Area','20 km'),
          Container(height: 10),
          _filterRow('Age','25 ans'),
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
          TextSpan(
              text: 'people !', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _filterRow(String s, String s2) {
    return Row(
      children: <Widget>[
        Container(
          width: 100,
          child: Text(s,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        Container(
          width: 100,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
              left: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
              right: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
              bottom: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Color(0xFFFFDFDFDF)),
                left: BorderSide(width: 1.0, color: Color(0xFFFFDFDFDF)),
                right: BorderSide(width: 1.0, color: Color(0xFFFF7F7F7F)),
                bottom: BorderSide(width: 1.0, color: Color(0xFFFF7F7F7F)),
              ),
            ),
            child: Text(
                s2,
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF000000))
            ),
          ),
        )
      ],
    );
  }
}
