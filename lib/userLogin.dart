import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:learn_shopmall/myService.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({Key? key}) : super(key: key);

  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final formKey = GlobalKey<FormState>();
  String? emailString, passwordString;

  Widget backToHomeButton() {
    return IconButton(
      icon: Icon(
        Icons.navigate_before,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget loginFLoatingButton() {
    return FloatingActionButton(
      //child: Text('Login'),
      child: Icon(Icons.login),
      onPressed: () {
        print("Login is pressed");
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          print('$emailString    $passwordString');
          //logingAuthCallback(emailString.toString(), passwordString.toString());
          loginAuth(emailString.toString(), passwordString.toString());
        }
      },
    );
  }

  Future<void> loginAuth(String email, String password) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (context) {
        return MyService();
      });
      Navigator.of(context)
          .pushAndRemoveUntil(materialPageRoute, (route) => false);
    } on FirebaseAuthException catch (e) {
      print('RESPONSE  ${e.code}, ${e.message}');
      alertLoginError(e.code, e.message);
    }
  }

  void logingAuthCallback(String email, String password) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (context) {
        return MyService();
      });
      Navigator.of(context)
          .pushAndRemoveUntil(materialPageRoute, (route) => false);
    }
            // , onError: (e) {
            //   print(' little small e error .');
            //   print(e);
            // }
            ).catchError((onError) {
      print('---RESPONSE---');
      print('Response: $onError');
    });
  }

  void alertLoginError(String title, String? message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: ListTile(
              leading: Icon(
                Icons.add_alert,
                color: Colors.redAccent,
                size: 48,
              ),
              title: Text(
                title,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            content: Text(message!),
            actions: [
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget shopLogo() {
    return Container(height: 50, child: Image.asset("assets/icons/bag.png"));
  }

  Widget shopName() {
    return Text(
      'Learn Shopping Malls',
      style: TextStyle(
          color: Colors.indigo.shade900,
          fontSize: 20,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          fontFamily: 'LobsterTwo'),
    );
  }

  Widget brandShow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        shopLogo(),
        shopName(),
      ],
    );
  }

  Widget emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          icon: Icon(
            Icons.face,
            size: 38,
            color: Colors.indigo.shade600,
          ),
          labelText: 'Email:',
          labelStyle: TextStyle(
              fontSize: 18,
              color: Colors.indigo.shade600,
              fontWeight: FontWeight.bold)),
      validator: MultiValidator([
        RequiredValidator(errorText: 'Please,Enter email address'),
        EmailValidator(errorText: 'Must be email format')
      ]),
      onSaved: (email) {
        emailString = email;
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
          icon: Icon(
            Icons.lock,
            size: 38,
            color: Colors.indigo.shade600,
          ),
          labelText: 'Password:',
          labelStyle: TextStyle(
              fontSize: 18,
              color: Colors.indigo.shade600,
              fontWeight: FontWeight.bold)),
      validator: RequiredValidator(errorText: 'It can not empty.'),
      onSaved: (newValue) {
        passwordString = newValue;
      },
    );
  }

  Widget content() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                brandShow(),
                emailField(),
                passwordField(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(
                radius: 1,
                colors: [Colors.yellow.shade200, Colors.red.shade600])),
        child: Stack(
          children: [
            backToHomeButton(),
            content(),
          ],
        ),
      )),
      floatingActionButton: loginFLoatingButton(),
    );
  }
}
