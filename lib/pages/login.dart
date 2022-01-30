import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup.dart';
import 'profile.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginState(),
    );
  }
}

class LoginState extends StatefulWidget {
  const LoginState({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Login();
  }
}

class _Login extends State<LoginState> {
  String email = "";
  String password = "";
  String infoText = "";

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
                  password = value;
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
              // height: 100.0,
              child: ElevatedButton(
                child: const Text(
                  'Login',
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
                  fixedSize: const Size(320, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () async {
                  try {
                    credential = await auth.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    user = credential.user!;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile(userId: user.uid),
                      ),
                    );
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      infoText = e.message!;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ButtonTheme(
            minWidth: 350.0,
            child: ElevatedButton(
              child: const Text(
                'Sign Up',
              ),
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(255, 255, 255, 0.0),
                fixedSize: const Size(320, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (BuildContext context) => const SignUp(),
                  ),
                );
              },
            ),
          ),
        ),
      ]),
    );
  }
}
