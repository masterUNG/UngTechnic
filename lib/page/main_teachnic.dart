import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungteachnic/page/informaion.dart';
import 'package:ungteachnic/page/order.dart';
import 'package:ungteachnic/page/referance.dart';
import 'package:ungteachnic/utility/my_style.dart';

class MainTeachnic extends StatefulWidget {
  @override
  _MainTeachnicState createState() => _MainTeachnicState();
}

class _MainTeachnicState extends State<MainTeachnic> {
  String nameLogin;
  Widget currentWidget = Order();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findLogin();
  }

  Future<Null> findLogin() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uid = event.uid;
        // print('uid = $uid');
        await FirebaseFirestore.instance
            .collection('User')
            .doc('Technicial')
            .collection('Information')
            .doc(uid)
            .snapshots()
            .listen((event) {
          setState(() {
            nameLogin = event.data()['Name'];
            // print('nameLogin = $nameLogin');
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: currentWidget,
      drawer: buildDrawer(context),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Column(
            children: [
              buildUserAccountsDrawerHeader(),
              buildListTileOrder(),
              buildListTileInformation(),
              buildListTileReferance(),
            ],
          ),
          MyStyle().buildSingOut(context),
        ],
      ),
    );
  }

  ListTile buildListTileOrder() => ListTile(
        leading: Icon(Icons.shopping_cart),
        title: Text('Read Order'),
        subtitle: Text('Read Order From User'),
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentWidget = Order();
          });
        },
      );

  ListTile buildListTileInformation() => ListTile(
        leading: Icon(Icons.info),
        title: Text('Information'),
        subtitle: Text('Read Informaion From Technicial'),
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentWidget = Information();
          });
        },
      );

  ListTile buildListTileReferance() => ListTile(
        leading: Icon(Icons.refresh),
        title: Text('Referance'),
        subtitle: Text('Job Referance'),
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentWidget = Referance();
          });
        },
      );

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/wall.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      currentAccountPicture: Image.asset('images/logo.png'),
      accountName: Text(
        nameLogin == null ? 'Name' : nameLogin,
        style: TextStyle(color: MyStyle().darkColor),
      ),
      accountEmail: Text(
        'Technicial',
        style: TextStyle(color: MyStyle().darkColor),
      ),
    );
  }
}
