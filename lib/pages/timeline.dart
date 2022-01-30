import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:crypto/crypto.dart';
import 'dart:io';
import 'dart:convert';
import 'package:pics_share/pages/photo_detail.dart';
import 'package:pics_share/pages/profile.dart';

const MaterialColor white = MaterialColor(
  0xFFFFFFFF,
  <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(0xFFFFFFFF),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  },
);

class Timeline extends StatelessWidget {
  const Timeline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: white),
      home: const TimelineState(),
    );
  }
}

class TimelineState extends StatefulWidget {
  const TimelineState({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Timeline();
  }
}

class _Timeline extends State<TimelineState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Pics Share',
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemCount: 20,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PhotoDetail()),
                );
              },
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(1.0, 0.0, 1.0, 2.0),
                      child: Image.network(
                        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 6.0,
        shape: const AutomaticNotchedShape(
          RoundedRectangleBorder(),
          StadiumBorder(side: BorderSide()),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.timeline_outlined),
              ),
              IconButton(
                onPressed: () {
                  late File _image;
                  final ImagePicker _picker = ImagePicker();
                  Future _upload() async {
                    final pickedFile =
                        await _picker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      _image = File(pickedFile!.path);
                    });
                    FirebaseStorage storage = FirebaseStorage.instance;
                    try {
                      final _encoded = utf8.encode(
                          p.basename(pickedFile!.path) +
                              DateTime.now().millisecondsSinceEpoch.toString());
                      final _fileName = sha256.convert(_encoded);
                      await storage
                          .ref('uploaded/${_fileName.toString()}')
                          .putFile(_image);
                    } catch (e) {
                      print(e);
                    }
                  }

                  _upload();
                },
                icon: const Icon(Icons.add_a_photo_outlined),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Profile(),
                    ),
                  );
                },
                icon: const Icon(Icons.person_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}