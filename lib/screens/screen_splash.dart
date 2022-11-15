import 'dart:async';

import 'package:app_todo/screens/screen_todo.dart';
import 'package:app_todo/screens/screen_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  // bool isFirebaseInitialized = false;
  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
    // setState(() {
    //   isFirebaseInitialized = true;
    // });

    // kullanıcı login olmuşsa
    if (FirebaseAuth.instance.currentUser != null) {
      Timer(
        const Duration(seconds: 3),
        () => _goToMainScreen(),
      );
    } else {
      Timer(
        const Duration(seconds: 3),
        () => _goToLoginScreen(),
      );
    }
  }

  void _goToMainScreen() {
    //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ScreenPhotosWithBloc()));

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ScreenTodo()));
  }

  void _goToLoginScreen() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ScreenLogin()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              "images/photo_icon.png",
              width: 300,
              height: 300,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: SizedBox(
                width: 150,
                height: 15,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.orange,
                )),
          )
        ],
      ),
    );
  }
}
