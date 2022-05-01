import 'package:flutter/material.dart';
import 'package:pics_share/models/account.dart';
import 'package:pics_share/pages/timeline_page.dart';
import 'package:pics_share/utils/user_preferences.dart';
import 'package:pics_share/widgets/profile_widget.dart';
import 'package:pics_share/widgets/textfield_widget.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Account user = UserPreferences.myUser;

  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 32),
              physics: BouncingScrollPhysics(),
              children: [
                ProfileWidget(
                  imagePath: user.imagePath,
                  isEdit: true,
                ),
                const SizedBox(height: 24),
                TextFieldWidget(
                  label: 'User Name',
                  text: user.name,
                  onChanged: (name) {},
                ),
              ],
            ),
          ),
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
        ),
      );
}
