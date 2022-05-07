import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:crypto/crypto.dart';
import 'dart:io';
import 'dart:convert';
import 'package:pics_share/pages/profile_page.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const TimelinePageState(),
    );
  }
}

class TimelinePageState extends StatefulWidget {
  const TimelinePageState({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TimelinePage();
  }
}

class _TimelinePage extends State<TimelinePageState> {
  FirebaseStorage storage = FirebaseStorage.instance;

  _dialogCall(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('You will upload this image.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<List<String>> _loadImages() async {
    List<String> files = [];
    final ListResult result = await storage.ref().child("creatives").list();
    final List<Reference> allFiles = result.items;
    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      files.add(fileUrl);
    });
    return files;
  }

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
        child: FutureBuilder(
          future: _loadImages(),
          builder: (context, AsyncSnapshot<List<String>> snapshot) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(1.0, 0.0, 1.0, 2.0),
                  child: Image.network(
                    snapshot.data![index],
                    width: 200,
                    height: 200,
                    fit: BoxFit.fitWidth,
                  ),
                );
              },
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
                onPressed: () {
                  _loadImages();
                },
                icon: const Icon(Icons.timeline_outlined),
              ),
              IconButton(
                onPressed: () {
                  late File _image;
                  final ImagePicker _picker = ImagePicker();
                  Future _upload() async {
                    final pickedFile =
                        await _picker.pickImage(source: ImageSource.gallery);
                    await _dialogCall(context);
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
                          .ref('creatives/${_fileName.toString()}')
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
                      builder: (context) => const ProfilePage(),
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
