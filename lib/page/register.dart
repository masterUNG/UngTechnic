import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungteachnic/utility/my_style.dart';
import 'package:ungteachnic/utility/normal_dialog.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String chooseType, name, user, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().primaryColor,
        title: Text('New Register'),
      ),
      body: Stack(
        children: [
          buildCenter(),
          buildRaisedButton(),
        ],
      ),
    );
  }

  Widget buildRaisedButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: RaisedButton.icon(
            color: MyStyle().primaryColor,
            onPressed: () {
              if (name == null ||
                  name.isEmpty ||
                  user == null ||
                  user.isEmpty ||
                  password == null ||
                  password.isEmpty) {
                normalDialog(context, 'Have Space ? Please Fill Every Blank');
              } else if (chooseType == null) {
                normalDialog(context, 'Please Choose Type User');
              } else {
                registerThread();
              }
            },
            icon: Icon(Icons.cloud_upload),
            label: Text(
              'Register',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCenter() {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              MyStyle().mySizebox(),
              buildName(),
              MyStyle().mySizebox(),
              buildContainer(),
              MyStyle().mySizebox(),
              buildUser(),
              MyStyle().mySizebox(),
              buildPassword(),
            ],
          ),
        ],
      ),
    );
  }

  Container buildContainer() {
    return Container(
      width: 250,
      child: Column(
        children: [
          MyStyle().showTitle('Type User :'),
          Row(
            children: [
              MyStyle().mySizebox(),
              Radio(
                value: 'User',
                groupValue: chooseType,
                onChanged: (value) {
                  setState(() {
                    chooseType = value;
                  });
                },
              ),
              Text('General User'),
            ],
          ),
          Row(
            children: [
              MyStyle().mySizebox(),
              Radio(
                value: 'Technicial',
                groupValue: chooseType,
                onChanged: (value) {
                  setState(() {
                    chooseType = value;
                  });
                },
              ),
              Text('Technicial'),
            ],
          ),
        ],
      ),
    );
  }

  Container buildName() {
    return Container(
      width: 250,
      child: TextField(
        onChanged: (value) => name = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.face,
            color: MyStyle().darkColor,
          ),
          hintText: 'Name :',
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

  Container buildUser() {
    return Container(
      width: 250,
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) => user = value.trim(),
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
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock_outline,
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

  Future<Null> registerThread() async {
    await Firebase.initializeApp().then((value) async {
      print('Firebase Success');
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: user, password: password)
          .then((value) async {
        String uid = value.user.uid;
        print('Register Success uid = $uid');

        Map<String, dynamic> map = Map();
        map['Type'] = chooseType;

        await FirebaseFirestore.instance.collection('Type').doc(uid).set(map);

        Map<String, dynamic> data = Map();
        data['Name'] = name;

        await FirebaseFirestore.instance
            .collection('User')
            .doc(chooseType)
            .collection('Information')
            .doc(uid)
            .set(data)
            .then((value) => Navigator.pop(context));
      }).catchError((value) {
        normalDialog(context, value.message);
      });
    });
  }
}
