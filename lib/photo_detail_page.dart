import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pics_share/main.dart';
import 'package:pics_share/profile_page.dart';

final photoRef =
    FirebaseFirestore.instance.collection('photos').withConverter<Photo>(
      fromFirestore: (snapshots, _) => Photo.fromJson(snapshots.data()!),
      toFirestore: (photo, _) => photo.toJson(),
    );

enum PhotoQuery {
  time,
}

extension on Query<Photo> {
  Query<Photo> queryBy(PhotoQuery query) {
    switch (query) {
      case PhotoQuery.time:
        return orderBy('time', descending: true);
    }
  }
}

class PhotoDetailPage extends StatelessWidget {
  const PhotoDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: white),
      home: Scaffold(
        body: const Center(
          child: PhotoList(),
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
      ),
    );
  }
}

class PhotoList extends StatefulWidget {
  const PhotoList({Key? key}) : super(key: key);

  @override
  _PhotoListState createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  late Query<Photo> _photosQuery;
  late Stream<QuerySnapshot<Photo>> _photos;

  @override
  void initState() {
    super.initState();
    _updatePhotosQuery(PhotoQuery.time);
  }

  void _updatePhotosQuery(PhotoQuery query) {
    setState(() {
      _photosQuery = photoRef.queryBy(query);
      _photos = _photosQuery.snapshots();
    });
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
      body: StreamBuilder<QuerySnapshot<Photo>>(
        stream: _photos,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;

          return ListView.builder(
            itemCount: data.size,
            itemBuilder: (context, index) {
              return _PhotoItem(
                data.docs[index].data(),
                data.docs[index].reference,
              );
            },
          );
        },
      ),
    );
  }
}

class _PhotoItem extends StatelessWidget {
  const _PhotoItem(this.photo, this.reference);

  final Photo photo;
  final DocumentReference<Photo> reference;

  Widget get poster {
    return SizedBox(
      width: double.infinity,
      child: Image.network(photo.poster),
    );
  }

  Widget get details {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          genres,
          Likes(
            reference: reference,
            currentLikes: photo.likes,
          ),
          time,
        ],
      ),
    );
  }

  Widget get title {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4.0, 12.0, 0.0, 2.0),
      child: Text(
        photo.title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget get time {
    return Text(
      'Uploaded: ${photo.time}',
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    );
  }

  List<Widget> get genreItems {
    return [
      for (final genre in photo.genre)
        Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Chip(
            backgroundColor: Colors.blueAccent,
            label: Text(
              genre,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        )
    ];
  }

  Widget get genres {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        children: genreItems,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          poster,
          details,
        ],
      ),
    );
  }
}

class Likes extends StatefulWidget {
  const Likes({
    Key? key,
    required this.reference,
    required this.currentLikes,
  }) : super(key: key);

  final DocumentReference<Photo> reference;

  final int currentLikes;

  @override
  _LikesState createState() => _LikesState();
}

class _LikesState extends State<Likes> {
  late int _likes = widget.currentLikes;

  Future<void> _onLike() async {
    final currentLikes = _likes;

    setState(() {
      _likes = currentLikes + 1;
    });

    try {
      int newLikes = await FirebaseFirestore.instance
          .runTransaction<int>((transaction) async {
        DocumentSnapshot<Photo> photo =
            await transaction.get<Photo>(widget.reference);

        if (!photo.exists) {
          throw Exception('Document does not exist!');
        }

        int updatedLikes = photo.data()!.likes + 1;
        transaction.update(widget.reference, {'likes': updatedLikes});
        return updatedLikes;
      });

      setState(() => _likes = newLikes);
    } catch (e, s) {
      print(s);
      print('Failed to update likes for document! $e');

      setState(() => _likes = currentLikes);
    }
  }

  @override
  void didUpdateWidget(Likes oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentLikes != oldWidget.currentLikes) {
      _likes = widget.currentLikes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          iconSize: 20,
          onPressed: _onLike,
          icon: const Icon(Icons.favorite),
        ),
        Text('$_likes likes'),
      ],
    );
  }
}

@immutable
class Photo {
  const Photo({
    required this.title,
    required this.poster,
    required this.genre,
    required this.likes,
    required this.time,
  });

  Photo.fromJson(Map<String, Object?> json)
      : this(
          title: json['title']! as String,
          poster: json['poster']! as String,
          genre: (json['genre']! as List).cast<String>(),
          likes: json['likes']! as int,
          time: json['time']! as String,
        );

  final String title;
  final String poster;
  final List<String> genre;
  final int likes;
  final String time;

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'poster': poster,
      'genre': genre,
      'likes': likes,
      'time': time,
    };
  }
}
