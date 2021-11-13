import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('powpow'),
          backgroundColor: Colors.transparent
        ),
        endDrawer: Drawer(
          child: ListView(
            children: const <Widget>[
              SizedBox(
                height: 48,
                child: DrawerHeader(child: Text('Settings'))
              ),
              ListTile(
                title: Text('Account'),
              ),
              ListTile(
                title: Text('Balance'),
              ),
              ListTile(
                title: Text('Log out'),
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.black,
          notchMargin: 6.0,
          shape: const AutomaticNotchedShape(
            RoundedRectangleBorder(),
            StadiumBorder(
              side: BorderSide()
            )
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.timeline_outlined,
                      color: Colors.white,
                    )
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.find_in_page_outlined,
                      color: Colors.white,
                    )
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.person_outline,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}

final FirebaseAuth _auth = FirebaseAuth.instance;
