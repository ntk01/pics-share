import 'package:flutter/material.dart';
import 'package:pics_share/models/account.dart';
import 'package:pics_share/pages/timeline_page.dart';
import 'package:pics_share/pages/edit_profile_page.dart';
import 'package:pics_share/widgets/profile_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: _ProfilePageState(),
    );
  }
}

class _ProfilePageState extends StatefulWidget {
  const _ProfilePageState({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfilePage();
  }
}

class _ProfilePage extends State<_ProfilePageState> {
  @override
  Widget build(BuildContext context) {
    const user = Account(
      name: 'ntaku',
      email: 'test@gmail.com',
      imagePath:
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
    );

    return Builder(
        builder: (context) => Scaffold(
              body: Center(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(60.0, 30.0, 60.0, 0.0),
                  shrinkWrap: true,
                  children: [
                    ProfileWidget(
                      imagePath: user.imagePath,
                    ),
                    buildName(user),
                    OutlinedButton(
                      child: const Text('Edit Profile'),
                      style: OutlinedButton.styleFrom(
                        primary: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: BottomAppBar(
                notchMargin: 6.0,
                shape: const AutomaticNotchedShape(RoundedRectangleBorder(),
                    StadiumBorder(side: BorderSide())),
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
                            MaterialPageRoute(
                                builder: (context) => const TimelinePage()),
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
            ));
  }

  Widget buildName(Account account) => Column(
        children: [
          Text(
            account.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ],
      );

  Widget buildAbout(Account account) => Container();
}
