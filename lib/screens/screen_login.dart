import 'package:app_todo/services/firebase_auth.dart';
import 'package:app_todo/services/google_services.dart';
import 'package:app_todo/screens/photos_with_bloc.dart';
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
  bool isFirebaseInitialized = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService _authService = AuthService();

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
      _goToMainScreen();
    }
  }

  void _goToMainScreen() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ScreenPhotosWithBloc()));
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
        body: isFirebaseInitialized
            ? Padding(
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
                          onPressed: () {
                            // _signIn().then((value) {
                            //   emailController.clear();
                            //   passwordController.clear();
                            //   if (FirebaseAuth.instance.currentUser != null) {
                            //     _goToMainScreen();
                            //   }
                            // });

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
                          // await signInWithGoogle();
                          // _goToMainScreen();

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
              )
            : const Center(child: CircularProgressIndicator()));
  }
}
