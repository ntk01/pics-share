import 'package:flutter/material.dart';
import 'package:pics_share/main.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: white),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Pics Share',
          ),
        ),
        body: const Center(),
        bottomNavigationBar: BottomAppBar(
          notchMargin: 6.0,
          shape: const AutomaticNotchedShape(
              RoundedRectangleBorder(), StadiumBorder(side: BorderSide())),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => App()),
                    );
                  },
                  icon: const Icon(Icons.timeline_outlined),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add_a_photo_outlined),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.person_outline),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
