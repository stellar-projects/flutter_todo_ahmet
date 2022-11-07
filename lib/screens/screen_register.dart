import 'package:app_todo/screens/photos_with_bloc.dart';
import 'package:app_todo/screens/screen_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/firebase_auth.dart';

class ScreenRegister extends StatefulWidget {
  const ScreenRegister({super.key});

  @override
  State<ScreenRegister> createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _goToMainScreen() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ScreenPhotosWithBloc()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Kayıt Ol"),
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
                child: ElevatedButton(
                  onPressed: () {
                    // _signUp().then((value) {
                    //   if (FirebaseAuth.instance.currentUser != null) {
                    //     _goToMainScreen();
                    //   }
                    // });
                    _authService
                        .signUp(emailController.text.trim(),
                            passwordController.text.trim(), context)
                        .then((value) {
                      if (FirebaseAuth.instance.currentUser != null) {
                        _goToMainScreen();
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text("Sign Up"),
                ),
              ),
            ],
          ),
        ));
  }
}
