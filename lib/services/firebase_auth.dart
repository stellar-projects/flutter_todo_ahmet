import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signIn(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        // showDialog(
        //     context: context,
        //     builder: (context) {
        //       return AlertDialog(
        //         title: Text(e.code.replaceAll("-", " ")),
        //       );
        //     });
        errorShowDialog(context, e);
      } else {
        print(e.message);
      }
    } catch (e) {
      print(e);
    }
  }

  Future signUp(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        errorShowDialog(context, e);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> errorShowDialog(
      BuildContext context, FirebaseAuthException e) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(e.code.replaceAll("-", " ")),
          );
        });
  }
}
