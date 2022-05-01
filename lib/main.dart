import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pics_share/pages/login_page.dart';
import 'package:pics_share/pages/timeline_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      runApp(const LoginPage());
    }
  });

  runApp(const TimelinePage());
}
