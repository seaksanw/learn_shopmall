import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_shopmall/myService.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  late String nameString, emailString, passwordString;
  Widget registerButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          print("$nameString  $emailString  $passwordString");
          registerThread();
        }
        print("upload Pressed");
      },
    );
  }

  Future<void> registerThread() async {
    try {
      // UserCredential userCredential = await FirebaseAuth.instance
      //     .createUserWithEmailAndPassword(
      //         email: emailString, password: passwordString);
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
              email: emailString, password: passwordString);
      // await userCredential.user!.updateDisplayName(nameString);
      // print(
      //     'Displayname: ------------------------> ${userCredential.user!.displayName}');
      await setupDisplayName();
      // var user = FirebaseAuth.instance.currentUser;
      // print('Displayname: ========================> ${user!.displayName}');
    } on FirebaseAuthException catch (e) {
      String title = e.code;
      String? message = e.message;
      myAlert(title, message);

      print('Respone Code: $title  , message: $message');
    }
  }

  Future<void> setupDisplayName() async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      var user = firebaseAuth.currentUser;
      if (user != null) {
        await user.updateDisplayName(nameString);
        //   print(
        //       '>>>>>>>>>>>>>>>>>>>>>>>DISPLAYNAME: ${user.displayName} EMAIL: ${user.email}');
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (context) {
          return MyService();
        });
        Navigator.of(context)
            .pushAndRemoveUntil(materialPageRoute, (route) => false);
      }
    } on FirebaseException catch (e) {
      print('?????????????? setup DisplayName error ${e.code}');
    }
  }
  // Future<void> registerThread() async {
  //   FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //   await firebaseAuth
  //       .createUserWithEmailAndPassword(
  //           email: emailString, password: passwordString)
  //       .then((response) {
  //     print('Register success for email : $emailString');
  //   }).catchError((response) {
  //     String title = response.code;
  //     String message = response.message;
  //     myAlert(title, message);
  //     print('Respone Code: $title  , message: $message');
  //   });
  // }

  void myAlert(String title, String? message) {
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

  Widget nameField() {
    return TextFormField(
      style: TextStyle(color: Colors.black54),
      decoration: InputDecoration(
          icon: Icon(
            Icons.face,
            size: 48,
            color: Colors.indigo.shade600,
          ),
          labelText: 'Your Display Name:',
          labelStyle: TextStyle(
            color: Colors.indigo.shade600,
            fontWeight: FontWeight.bold,
          ),
          helperText: 'Type your nick name for display.',
          helperStyle: TextStyle(
              color: Colors.indigo.shade600, fontStyle: FontStyle.italic)),
      validator: (name) {
        if (name!.isEmpty) {
          return 'This field can not empty.';
        }
      },
      onSaved: (String? name) {
        nameString = name!;
      },
    );
  }

  Widget emailField() {
    return TextFormField(
      style: TextStyle(color: Colors.black54),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          icon: Icon(
            Icons.email,
            size: 48,
            color: Colors.indigo.shade600,
          ),
          labelText: 'Your Email Address:',
          labelStyle: TextStyle(
            color: Colors.indigo.shade600,
            fontWeight: FontWeight.bold,
          ),
          helperText: 'Type your email address.',
          helperStyle: TextStyle(
              color: Colors.indigo.shade600, fontStyle: FontStyle.italic)),
      validator: (email) {
        if (email!.isEmpty) {
          return 'This field can not empty.';
        } else {
          if (!(email.contains('@') && email.contains('.'))) {
            return 'Please enter in email format';
          }
        }
      },
      onSaved: (email) {
        emailString = email!;
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      style: TextStyle(color: Colors.black54),
      decoration: InputDecoration(
          icon: Icon(
            Icons.lock,
            size: 48,
            color: Colors.indigo.shade600,
          ),
          labelText: 'Create Your Password:',
          labelStyle: TextStyle(
            color: Colors.indigo.shade600,
            fontWeight: FontWeight.bold,
          ),
          helperText: 'At least 6 characters',
          helperStyle: TextStyle(
              color: Colors.indigo.shade600, fontStyle: FontStyle.italic)),
      validator: (passwd) {
        if (passwd!.length < 6) {
          return 'Enter at least 6 chaaracters';
        }
      },
      onSaved: (String? passwd) {
        passwordString = passwd!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Register',
            style: TextStyle(color: Colors.indigo.shade900),
          ),
          //backgroundColor: Colors.deepOrange.shade600,
          foregroundColor: Colors.indigo.shade900,
          actions: [
            registerButton(),
          ],
        ),
        body: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.all(30),
            children: [
              nameField(),
              emailField(),
              passwordField(),
            ],
          ),
        ));
  }
}
