import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungteachnic/models/technic_model.dart';
import 'package:ungteachnic/page/add_informaion.dart';
import 'package:ungteachnic/utility/my_style.dart';

class Information extends StatefulWidget {
  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  TechnicModel model;
  bool statusCheck = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  Future<Null> readData() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        await FirebaseFirestore.instance
            .collection('User')
            .doc('Technicial')
            .collection('Information')
            .doc(event.uid)
            .snapshots()
            .listen((event) {
          setState(() {
            model = TechnicModel.fromJson(event.data());
            statusCheck = false;
          });
          print('name = ${model.name}, urlAvatar ==> ${model.urlAvatar}');
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddInformation(),
          ),
        ).then(
          (value) => readData(),
        ),
        child: Icon(
          Icons.add_circle_outline,
          size: 48,
        ),
      ),
      body: statusCheck
          ? MyStyle().showProgress()
          : model.urlAvatar == null
              ? Center(
                  child: MyStyle().showTitle('No Informaion Please Add'),
                )
              : Text('Have Data'),
    );
  }
}
