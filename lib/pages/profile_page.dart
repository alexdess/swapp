import 'package:Swapp/services/authentification.dart';
import 'package:Swapp/widget/ReusableAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final Firestore firestore = new Firestore();
  final BaseAuth auth = new Auth();
  final Function logoutCallback;

  ProfilePage(this.logoutCallback);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = new GlobalKey<FormState>();
  String _telNumber;
  String _email;
  String _address;
  String _name;
  String _errorMessage;
  String _village;
  String _postalCode;

  @override
  void initState() {
    super.initState();
    _setInfos();
    _errorMessage = "";
  }

  void _setInfos() async {
    var userId = widget.auth.getCurrentUserId();
    widget.firestore
        .collection(userId)
        .document("Infos")
        .get()
        .then((snapshot) => _setInfos2(snapshot));
  }

  _setInfos2(DocumentSnapshot snapshot) {
    setState(() {
      _name = snapshot['name'] ?? "";
      _telNumber = snapshot['tel'] ?? "";
      _address = snapshot['adress'] ?? "";
      _email = snapshot['email'] ?? "";
      _postalCode = snapshot['postalCode'] ?? "";
      _village = snapshot['village'] ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar().setAppBar(context, "Sw'app"),
      body: new Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            showNameInput(),
            showEmailInput(),
            showAdresseInput(),
            showPostalCodeInput(),
            showVillageInput(),
            showTelInput(),
            showPrimaryButton(),
            showLogoutClickableText(),
            showErrorMessage(),
          ],
        ),
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
            child: new Text('Sauver'),
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

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        controller: new TextEditingController(text: _email),
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showAdresseInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        controller: new TextEditingController(text: _address),
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Adresse',
            icon: new Icon(
              Icons.account_balance,
              color: Colors.grey,
            )),
        validator: (value) =>
            value.isEmpty ? 'adresse ne peux pas être vite' : null,
        onSaved: (value) => _address = value.trim(),
      ),
    );
  }

  Widget showNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        controller: new TextEditingController(text: _name),
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Nom',
            icon: new Icon(
              Icons.person,
              color: Colors.grey,
            )),
        validator: (value) =>
            value.isEmpty ? 'le nom ne peux pas être vite' : null,
        onSaved: (value) => _name = value.trim(),
      ),
    );
  }

  Widget showVillageInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        controller: new TextEditingController(text: _village),
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Ville',
            icon: new Icon(
              Icons.confirmation_number,
              color: Colors.grey,
            )),
        validator: (value) =>
            value.isEmpty ? 'la ville ne peux pas être vite' : null,
        onSaved: (value) => _village = value.trim(),
      ),
    );
  }

  Widget showPostalCodeInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        controller: new TextEditingController(text: _postalCode),
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Code postal',
            icon: new Icon(
              Icons.code,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty || value.length > 4
            ? 'code postal incorrect (exemple: 1782)'
            : null,
        onSaved: (value) => _postalCode = value.trim(),
      ),
    );
  }

  Widget showTelInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        controller: new TextEditingController(text: _telNumber),
        maxLines: 1,
        keyboardType: TextInputType.phone,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Numéro de téléphone',
            icon: new Icon(
              Icons.phone,
              color: Colors.grey,
            )),
        validator: (value) =>
            value.isEmpty ? 'le numéro ne peux pas être vite' : null,
        onSaved: (value) => _telNumber = value.trim(),
      ),
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
    });
    if (validateAndSave()) {
      print('form is validate');
      String userId = "";
      try {
        userId = widget.auth.getCurrentUserId();
        widget.firestore
            .collection(userId)
            .document("Infos")
            .setData(<String, dynamic>{
          'adress': _address,
          'tel': _telNumber,
          'name': _name,
          'email': _email,
          'postalCode': _postalCode,
          'village': _village,
          'dateEnregistrement': FieldValue.serverTimestamp(),
        });
        Navigator.pop(context);
      } catch (e) {
        print('Error: $e');
        setState(() {
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  showLogoutClickableText() {
    return new FlatButton(
        child: new Text('Se déconnecter',
            style: new TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w300,
                color: Colors.red)),
        onPressed: _disconnectUser);
  }

  void _disconnectUser() {
    widget.logoutCallback();
  }
}
