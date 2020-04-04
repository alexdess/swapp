
import 'package:Swapp/services/authentification.dart';
import 'package:Swapp/widget/ReusableAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({this.auth, this.loginCallback,this.firestore});

  final BaseAuth auth;
  final VoidCallback loginCallback;
  final Firestore firestore;

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState(firestore);
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  double _width = 0.0;
  double _height = 0.0;

  _LoginSignupPageState(this.firestore);

  final _formKey = new GlobalKey<FormState>();
  final Firestore firestore;

  String _name;
  String _email;
  String _password;
  String _errorMessage;
  String _address;
  String _postalCode;
  String _village;
  String _telNumber;

  bool _isLoginForm;
  bool _isLoading;
  bool _isOverlayVisible=true;

  @override
  void initState() {
    super.initState();
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return new Scaffold(
        appBar: MyAppBar().setAppBar(context, "Sw'app"),
        body: Stack(
          children: <Widget>[
            _showForm(),
            _showCircularProgress(),
            getOverlayWidget()
          ],
        ));
  }

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      print('form is validate');
      String userId = "";
      try {
        if (_isLoginForm) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        }
        else {
          userId = await widget.auth.signUp(_email, _password);
          widget.auth.sendEmailVerification();
          if(userId != null && userId.isNotEmpty){

          firestore.collection(userId).document("Infos").setData(<String, dynamic>{
            'adress': _address,
            'tel': _telNumber,
            'name': _name,
            'email': _email,
            'postalCode': _postalCode,
            'village': _village,
            'dateEnregistrement' : FieldValue.serverTimestamp(),
          });
          print('Signed up user: $userId');
          }
        }
        setState(() {
          _isLoading = false;
        });

        if (userId != null && userId.length > 0) {

          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
    else{
      setState(() {
        _isLoading = false;
      });
    }
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget getOverlayWidget() {
    return new Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: _isOverlayVisible,
      child: Container(
        alignment: Alignment.topCenter,
        height: _height,
        width: _width,
        color: Colors.white.withOpacity(1),
        child: new ListView(
              children: [
                SizedBox(height: 50),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 48.0,
                          child: Image.asset('assets/icon-together.png'),
                        ),
                    ),
                    Expanded(
                      child: Text('Swa\'App est une application solidaire qui met en relation les demandeurs de services avec ceux qui peuvent y répondre.'),
                    ),
                    SizedBox(width: 50),
                  ],
                ),
                SizedBox(height: 50),
                Row(
                  children: <Widget>[
                    SizedBox(width: 50),
                    Expanded(
                      child: Text('Créer des requêtes tel que l\'achat de course, support et tout genre, etc. Les autres utilisateurs répondrons à vos demandes dans les plus brefs délais'),
                    ),
                    Expanded(
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 48.0,
                        child: Image.asset('assets/icon-shopping.png'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 48.0,
                        child: Image.asset('assets/icon-localisation.png'),
                      ),
                    ),
                    Expanded(
                      child: Text('Les requêtes sont géré selon la géolocalisation des utilisateurs.'),
                    ),
                    SizedBox(width: 50),
                  ],
                ),
                SizedBox(height: 50),
                Row(
                  children: <Widget>[
                    SizedBox(width: 50),
                    Expanded(
                      child: Text('AppYourService est une application solidaire qui met en relation les demandeurs de services avec ceux qui peuvent y répondre.'),
                    ),
                    Expanded(
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 48.0,
                        child: Image.asset('assets/icon-monney.png'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 48.0,
                        child: Image.asset('assets/icon-virus.png'),
                      ),
                    ),
                    Expanded(
                      child: Text('Il n\'y a aucun contact réel entre les utilisateurs. Chaque utilisateur est responsable de respecter les précautions du conseil fédéral. '),
                    ),
                    SizedBox(width: 50),
                  ],
                ),
                SizedBox(height: 50),
                new SizedBox(
                  width: 200.0,
                  height: 100.0,
                  child: new RaisedButton(
                    onPressed: (){setState(() {
                      _isOverlayVisible = false;
                    });},
                    child: const Text(
                        'J\'ai compris',
                        style: TextStyle(fontSize: 20)
                    ),
                  ),
                  ),
              ]
        ),
      ),
    );
  }

  Widget _showForm() {
    var signupContainer = new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showNameInput(),
              showEmailInput(),
              showAdresseInput(),
              showPostalCodeInput(),
              showVillageInput(),
              showTelInput(),
              showPasswordInput(),
              showPrimaryButton(),
              showSecondaryButton(),
              showErrorMessage(),
            ],
          ),
        ));
    var signInContainer = new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showEmailInput(),
              showPasswordInput(),
              showPrimaryButton(),
              showSecondaryButton(),
              showErrorMessage(),
            ],
          ),
        ));
    if(_isLoginForm){
      return signInContainer;
    }
    return signupContainer;
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
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

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/badge-ays.png'),
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
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
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Adresse',
            icon: new Icon(
              Icons.account_balance,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'adresse ne peux pas être vite' : null,
        onSaved: (value) => _address = value.trim(),
      ),
    );
  }  Widget showNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Nom',
            icon: new Icon(
              Icons.person,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'le nom ne peux pas être vite' : null,
        onSaved: (value) => _name = value.trim(),
      ),
    );
  }
  Widget showVillageInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Ville',
            icon: new Icon(
              Icons.home,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'la ville ne peux pas être vite' : null,
        onSaved: (value) => _village = value.trim(),
      ),
    );
  }
  Widget showPostalCodeInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Code postal',
            icon: new Icon(
              Icons.account_balance,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty || value.length > 4 ? 'code postal incorrect (exemple: 1782)' : null,
        onSaved: (value) => _postalCode = value.trim(),
      ),
    );
  }
  Widget showTelInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.phone,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Numéro de téléphone',
            icon: new Icon(
              Icons.phone,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'le numéro ne peux pas être vite' : null,
        onSaved: (value) => _telNumber = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text(
            _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
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
            child: new Text(_isLoginForm ? 'Login' : 'Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }
}