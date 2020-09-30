import 'package:flutter/material.dart';
import 'package:ungteachnic/utility/my_style.dart';

class MainUser extends StatefulWidget {
  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text('This is Main User'),
      drawer: Drawer(
        child: MyStyle().buildSingOut(context),
      ),
    );
  }

  
}
