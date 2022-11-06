import 'package:app_todo/google_sign_in.dart';
import 'package:app_todo/screens/photos_with_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  bool isFirebaseInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
    setState(() {
      isFirebaseInitialized = true;
    });
    // kullanıcı login olmuşsa
    if (FirebaseAuth.instance.currentUser != null) {
      _goToLoginScreen();
    }
  }

  void _goToLoginScreen() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ScreenPhotosWithBloc()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: isFirebaseInitialized
                ? SizedBox(
                    height: 40,
                    child:
                        SignInButton(Buttons.GoogleDark, onPressed: () async {
                      await signInWithGoogle();
                      _goToLoginScreen();
                    }),
                  )
                // ElevatedButton(
                //     onPressed: () async {
                //       await signInWithGoogle();
                //       _goToLoginScreen();
                //     },
                // child: const Text("Google Sign In"))
                : const CircularProgressIndicator()));
  }
}
