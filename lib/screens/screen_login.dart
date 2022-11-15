import 'package:app_todo/screens/screen_todo.dart';
import 'package:app_todo/services/firebase_auth.dart';
import 'package:app_todo/services/google_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'screen_register.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  void _goToMainScreen() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ScreenTodo()));
  }

  void _goToRegisterScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ScreenRegister()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Giriş Yap"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email")),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Şifre"),
                obscureText: true,
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(children: [
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () async {
                      print("pressed");

                      _authService
                          .signIn(emailController.text.trim(),
                              passwordController.text.trim(), context)
                          .then((value) {
                        emailController.clear();
                        passwordController.clear();
                        if (FirebaseAuth.instance.currentUser != null) {
                          _goToMainScreen();
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text("Sign In"),
                  )),
                  const SizedBox(width: 20),
                  Expanded(
                      child: ElevatedButton(
                    onPressed: _goToRegisterScreen,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text("Sign Up"),
                  )),
                ]),
              ),
              const SizedBox(height: 40),
              Center(
                  child: SizedBox(
                height: 40,
                child: SignInButton(
                  Buttons.GoogleDark,
                  onPressed: () {
                    signInWithGoogle().then((value) {
                      if (FirebaseAuth.instance.currentUser != null) {
                        _goToMainScreen();
                      }
                    }).catchError((e) {
                      print(e.toString());
                    });
                  },
                ),
              )),
            ],
          ),
        ));
  }
}
