import 'package:app_todo/screens/screen_todo.dart';
import 'package:app_todo/screens/screen_login.dart';
import 'package:app_todo/screens/screen_splash.dart';
import 'package:flutter/material.dart';
import 'injections/injection_container.dart';

void main() {
  initializeInjections();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScreenSplash(),
    );
  }
}
