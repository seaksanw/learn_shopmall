import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_shopmall/myService.dart';
import 'package:learn_shopmall/register.dart';
import 'package:learn_shopmall/userLogin.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool chk;

  @override
  void initState() {
    super.initState();
    chk = chkStatus();
  }

  bool chkStatus() {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var firebaseUser = firebaseAuth.currentUser;
    if (firebaseUser != null) {
      // MaterialPageRoute materialPageRoute =
      //     MaterialPageRoute(builder: (context) {
      //   return MyService();
      // });
      // Navigator.of(context)
      //     .pushAndRemoveUntil(materialPageRoute, (route) => false);
      return true;
    } else {
      return false;
    }
  }

  Widget shopLogo() {
    return Container(height: 150, child: Image.asset("assets/icons/bag.png"));
  }

  Widget shopName() {
    return Text(
      'Learn Shopping Malls',
      style: TextStyle(
          color: Colors.indigo.shade900,
          fontSize: 25,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          fontFamily: 'LobsterTwo'),
    );
  }

  Widget signInButton() {
    return ElevatedButton(
      child: Text('Sign In'),
      style: ElevatedButton.styleFrom(
        primary: Colors.indigo.shade900,
        onPrimary: Colors.white,
        shadowColor: Colors.red,
        elevation: 5,
        textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (context) {
          return UserLogin();
        });
        Navigator.of(context).push(materialPageRoute);
        // .pushAndRemoveUntil(materialPageRoute, (route) => false);
        print('SignIn Pressed');
      },
    );
  }

  Widget signUpButton() {
    return ElevatedButton(
      child: Text('Sign Up'),
      style: ElevatedButton.styleFrom(
        primary: Color.fromRGBO(255, 255, 255, 1),
        onPrimary: Colors.black,
        //shadowColor: Colors.red,
        side: BorderSide(color: Colors.black, width: 2),
        //elevation: 5,
        textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        print('SignUp Pressed');
        var materialPageRoute = MaterialPageRoute(builder: (context) {
          return Register();
        });
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  Widget forgetPasswd() {
    return TextButton(
        onPressed: () {},
        child: Text(
          "Forget your password?",
          style: TextStyle(fontSize: 15, color: Colors.white),
        ));
  }

  @override
  Widget build(BuildContext context) {
    // print('check:');
    // print(chk);
    if (chk == false) {
      //check ว่าเคยมีการ login ค้าง โดยไม่ได้ logout หรือไม่ (check ตอน initialState())
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(
                  radius: 1,
                  colors: [Colors.yellow.shade200, Colors.red.shade600])),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                shopLogo(),
                SizedBox(
                  height: 10,
                ),
                shopName(),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    signInButton(),
                    SizedBox(
                      width: 20,
                    ),
                    signUpButton(),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                forgetPasswd(),
              ],
            ),
          ),
        ),
      );
    } else {
      return MyService();
    }
  }
}
