import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_page.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SignUpState(),
    );
  }
}

class SignUpState extends StatefulWidget {
  const SignUpState({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SignUp();
  }
}

class _SignUp extends State<SignUpState> {
  String email = "";
  String password = "";
  String infoText = "";
  late bool isValidPasswordLength;

  final FirebaseAuth auth = FirebaseAuth.instance;
  late UserCredential credential;
  late User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 30.0),
              child: Text(
                'Sign Up',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "email",
                  hintText: "Enter your email",
                ),
                onChanged: (String value) {
                  email = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "password",
                  hintText: "Enter your password",
                ),
                obscureText: true,
                maxLength: 20,
                onChanged: (String value) {
                  if (value.length < 8) {
                    isValidPasswordLength = false;
                  } else {
                    isValidPasswordLength = true;
                    password = value;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 5.0),
              child: Text(
                infoText,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            ButtonTheme(
              minWidth: 350.0,
              child: ElevatedButton(
                child: const Text(
                  'Sign Up',
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
                  fixedSize: const Size(320, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () async {
                  if (isValidPasswordLength) {
                    try {
                      credential = await auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      user = credential.user!;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(),
                          ));
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        infoText = e.message!;
                      });
                    }
                  } else {
                    setState(
                      () {
                        infoText = 'Password is at least 8 characters.';
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
