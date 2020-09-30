import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungteachnic/page/main_teachnic.dart';
import 'package:ungteachnic/page/main_user.dart';
import 'package:ungteachnic/page/register.dart';
import 'package:ungteachnic/utility/my_style.dart';
import 'package:ungteachnic/utility/normal_dialog.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  bool statusCheck = true;
  String user, password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  Future<Null> checkLogin() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) {
        if (event != null) {
          String uid = event.uid;
          findType(uid);
        } else {
          setState(() {
            statusCheck = false;
          });
        }
      });
    });
  }

  Future<Null> findType(String uid) async {
    await FirebaseFirestore.instance
        .collection('Type')
        .doc(uid)
        .snapshots()
        .listen((event) {
      String type = event.data()['Type'];
      print('type Login ==> $type');
      switch (type) {
        case 'User':
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => MainUser(),
              ),
              (route) => false);
          break;
        case 'Technicial':
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => MainTeachnic(),
              ),
              (route) => false);
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
              colors: [Colors.white, Colors.lime],
              radius: 1,
              center: Alignment(0, -0.2)),
        ),
        child: statusCheck ? MyStyle().showProgress() : buildStack(),
      ),
    );
  }

  Stack buildStack() {
    return Stack(
      children: [
        buildContent(),
        buildFlatButton(),
      ],
    );
  }

  Column buildFlatButton() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_done),
              FlatButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Register(),
                  ),
                ),
                child: Text(
                  'New Regisger',
                  style: TextStyle(color: Colors.pink),
                ),
              ),
            ],
          ),
        ],
      );

  Center buildContent() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildLogo(),
          buildText(),
          MyStyle().mySizebox(),
          buildUser(),
          MyStyle().mySizebox(),
          buildPassword(),
          MyStyle().mySizebox(),
          buildRaisedButton(),
        ],
      ),
    );
  }

  Container buildRaisedButton() => Container(
        width: 250,
        child: RaisedButton(
          color: MyStyle().primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () {
            if (user == null ||
                user.isEmpty ||
                password == null ||
                password.isEmpty) {
              normalDialog(context, 'Have Space ? Please Fill Every Blank');
            } else {
              checkAuthen();
            }
          },
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

  Container buildUser() {
    return Container(
      width: 250,
      child: TextField(
        onChanged: (value) => user = value.trim(),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.account_circle,
            color: MyStyle().darkColor,
          ),
          hintText: 'User :',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyStyle().darkColor),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyStyle().primaryColor),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Container buildPassword() {
    return Container(
      width: 250,
      child: TextField(
        onChanged: (value) => password = value.trim(),
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
            color: MyStyle().darkColor,
          ),
          hintText: 'Password :',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyStyle().darkColor),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyStyle().primaryColor),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Text buildText() => Text(
        'อึ่ง ซ่อมด้ายยยย',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple.shade700,
        ),
      );

  Container buildLogo() {
    return Container(
      width: 120,
      child: Image.asset('images/logo.png'),
    );
  }

  Future<Null> checkAuthen() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: user, password: password)
          .then((value) {
        String uid = value.user.uid;
        findType(uid);
      }).catchError((value) {
        normalDialog(context, value.message);
      });
    });
  }
}
