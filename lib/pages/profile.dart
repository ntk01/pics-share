import 'package:flutter/material.dart';
import 'package:pics_share/pages/timeline.dart';

class Profile extends StatelessWidget {
  final String? userId;

  const Profile({Key? key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: white),
      home: const ProfileState(),
    );
  }
}

class ProfileState extends StatefulWidget {
  const ProfileState({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Profile();
  }
}

class _Profile extends State<ProfileState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    MaterialPageRoute(builder: (context) => const Timeline()),
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
    );
  }
}
