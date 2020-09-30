import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungteachnic/page/authen.dart';

class MyStyle {
  Color darkColor = Colors.blue.shade800;
  Color primaryColor = Colors.deepOrange.shade700;

  Widget mySizebox() => SizedBox(
        width: 16,
        height: 16,
      );

  Widget showTitle(String string) => Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.description),
          ),
          Text(
            string,
            style: TextStyle(fontSize: 16),
          ),
        ],
      );

  Widget showProgress() => Center(
        child: CircularProgressIndicator(),
      );

  Column buildSingOut(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.red.shade700),
          child: ListTile(
            onTap: () async {
              await Firebase.initializeApp().then((value) async {
                await FirebaseAuth.instance
                    .signOut()
                    .then((value) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Authen(),
                        ),
                        (route) => false));
              });
            },
            leading: Icon(
              Icons.exit_to_app,
              size: 36,
              color: Colors.white,
            ),
            title: Text(
              'Sing Out',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  MyStyle();
}
