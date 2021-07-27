import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_shopmall/homePage.dart';
import 'package:learn_shopmall/widgets/addProductPage.dart';
import 'package:learn_shopmall/widgets/listProductPage.dart';

class MyService extends StatefulWidget {
  const MyService({Key? key}) : super(key: key);

  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  String loginAccount = '...', displayName = '...';
  Widget currentWidget = ListProductPage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getDataAuthFromCurrentUser();
  }

  // Future<void> getDataAuthFromCurrentUser() async {
  void getDataAuthFromCurrentUser() {
    String _displayName = '[Can\'t get]', _loginAccount = '[Can\'t get]';
    // await Future.delayed(Duration(seconds: 10));
    print('In getData');
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    try {
      User? user = firebaseAuth.currentUser;
      _loginAccount = user!.email!;
      _displayName = user.displayName!;
    } catch (e) {
      // _displayName = '[Not Set]';
      // _loginAccount = '[Can\'t get]';
      print('Null ERROR:');
      print(e);
    }
    setState(() {
      loginAccount = _loginAccount;
      displayName = _displayName;
    });
  }

//Drawer zone

  Widget showShopLogo() {
    return Container(
      child: Image.asset('assets/icons/bag.png'),
      height: 80,
    );
  }

  Widget showShopName() {
    return Text(
      'Learn Shopping Mall',
      style: TextStyle(
        color: Colors.indigo.shade600,
        fontFamily: 'LobsterTwo',
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        fontSize: 18,
        shadows: [
          Shadow(
            blurRadius: 3.0,
            color: Colors.red,
            offset: Offset(2.0, 2.0),
          ),
          Shadow(
            color: Colors.red,
            blurRadius: 3.0,
            offset: Offset(-2.0, -2.0),
          ),
        ],
      ),
    );
  }

  Widget showUserAccount() {
    return Text(
      'Login By: $displayName',
      style: TextStyle(shadows: [
        Shadow(
          blurRadius: 3,
          color: Colors.red,
          offset: Offset(2, 2),
        ),
        Shadow(
          blurRadius: 3,
          color: Colors.red,
          offset: Offset(-2, -2),
        ),
      ]),
    );
  }

  Widget showHeadDrawer() {
    return DrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/shopping-bags640.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          showShopLogo(),
          showShopName(),
          SizedBox(
            height: 5,
          ),
          showUserAccount(),
        ],
      ),
    );
  }

  Widget showDrawer() {
    return Drawer(
      child: ListView(
        children: [
          showHeadDrawer(),
          Text('Account : $loginAccount'),
          showListProduct(),
          showAddProduct(),
        ],
      ),
    );
  }

  Widget showListProduct() {
    return ListTile(
      leading: Icon(
        Icons.list_alt,
        size: 36,
        color: Colors.indigo.shade600,
      ),
      title: Text('Products'),
      subtitle: Text('Show all products'),
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          currentWidget = ListProductPage();
        });
      },
    );
  }

  Widget showAddProduct() {
    return ListTile(
      leading:
          Icon(Icons.playlist_add, size: 36, color: Colors.indigo.shade600),
      title: Text('Add Product'),
      subtitle: Text('Add products to database'),
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          currentWidget = AddProductPage();
        });
      },
    );
  }

//main body zone
  Widget signOutButton() {
    return IconButton(
      icon: Icon(Icons.logout),
      onPressed: () {
        alertSingOut();
      },
      tooltip: 'Sing Out',
    );
  }

  void alertSingOut() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Sign Out',
              style: TextStyle(color: Colors.red),
            ),
            content: Text('Are you sure ?'),
            actions: [
              okButton(),
              cancelButton(),
            ],
          );
        });
  }

  Widget cancelButton() {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Cancel'));
  }

  Widget okButton() {
    return TextButton(
        onPressed: () {
          signOut();
        },
        child: Text('Ok'));
  }

  Future<void> signOut() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;
    //print('External if ');
    //print('user: $user');
    if (user != null) {
      //print('in if $user');
      await FirebaseAuth.instance.signOut();
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) {
        return HomePage();
      });
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Service'),
        actions: [
          signOutButton(),
        ],
      ),
      body: currentWidget,
      drawer: showDrawer(),
    );
  }
}
