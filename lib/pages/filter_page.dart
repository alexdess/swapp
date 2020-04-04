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
  String _areaKm;
  String _minAge;
  String _maxAge;

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
      appBar: MyAppBar()
          .setAppBar(context, "Sw'app", loginCallBack: widget.logoutCallback),
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
            label: Text(
              'Fully Random',
              style: TextStyle(fontSize: 25),
            ),
            onSelected: (bool value) {
              setState(() {
                _isRandomSelected = !_isRandomSelected;
                if (value) {
                  _isLanguageTraining = false;
                  _isParty = false;
                  _isCultural = false;
                  _isEntertainement = false;
                  _isDiscussion = false;
                }
              });
            },
          ),
          new CheckboxListTile(
            title: Text("Discussion"),
            value: _isDiscussion,
            onChanged: (bool value) {
              setState(() {
                _isDiscussion = !_isDiscussion;
                _isRandomSelected = value ? false : _isRandomSelected;
              });
            },
          ),
          new CheckboxListTile(
            title: Text("Entertainement"),
            value: _isEntertainement,
            onChanged: (bool value) {
              setState(() {
                _isEntertainement = !_isEntertainement;
                _isRandomSelected = value ? false : _isRandomSelected;
              });
            },
          ),
          new CheckboxListTile(
            title: Text("Cultural"),
            value: _isCultural,
            onChanged: (bool value) {
              setState(() {
                _isCultural = !_isCultural;
                _isRandomSelected = value ? false : _isRandomSelected;
              });
            },
          ),
          new CheckboxListTile(
            title: Text("Party"),
            value: _isParty,
            onChanged: (bool value) {
              setState(() {
                _isParty = !_isParty;
                _isRandomSelected = value ? false : _isRandomSelected;
              });
            },
          ),
          new CheckboxListTile(
            title: Text(
              "Language training",
            ),
            value: _isLanguageTraining,
            onChanged: (bool value) {
              setState(() {
                _isLanguageTraining = !_isLanguageTraining;
                _isRandomSelected = value ? false : _isRandomSelected;
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
          _filterRow('Area', '20 km', _changeArea),
          Container(height: 10),
          _filterRow('Age', '25 ans', _changeAgeRange),
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

  Widget _filterRow(String filterName, String value, Function onClick) {
    return Row(
      children: <Widget>[
        Container(
          width: 100,
          child: Text(
            filterName,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        GestureDetector(
            onTap: () {
              onClick();
            },
            child: Container(
              width: 100,
              height: 35,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
                  left: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
                  right: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
                  bottom: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
                ),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.0, color: Color(0xFFFF7F7F7F)),
                    left: BorderSide(width: 1.0, color: Color(0xFFFF7F7F7F)),
                    right: BorderSide(width: 1.0, color: Color(0xFFFF7F7F7F)),
                    bottom: BorderSide(width: 1.0, color: Color(0xFFFF7F7F7F)),
                  ),
                ),
                child: Center(
                  child: Text(value,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF000000))),
                ),
              ),
            )),
      ],
    );
  }

  _changeArea() {
    showDialog(
      context: context,

      builder: (BuildContext context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: new InputDecoration(
              hintText: '20 Km',
              icon: new Icon(
                Icons.map,
                color: Colors.grey,
              )),
          onSaved: (value) => _areaKm = value.trim(),
        ),
      ),
    );
  }

  _changeAgeRange() {
    showDialog(
      context: context,

      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
          height: 150,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.text,
              autofocus: false,
              decoration: new InputDecoration(
                  hintText: '18 years old',
                  icon: new Icon(
                    Icons.map,
                    color: Colors.grey,
                  )),
              onSaved: (value) => _minAge = value.trim(),
            ),
            TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.text,
              autofocus: false,
              decoration: new InputDecoration(
                  hintText: '30 years old',
                  icon: new Icon(
                    Icons.map,
                    color: Colors.grey,
                  )),
              onSaved: (value) => _maxAge = value.trim(),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
