import 'package:app_todo/screens/home_page.dart';
import 'package:app_todo/screens/screen_login.dart';
import 'package:flutter/material.dart';
import 'injections/injection_container.dart';
import 'screens/photos_with_bloc.dart';

void main() {
  initializeInjections();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScreenLogin(),
      // const ScreenPhotosWithBloc(),
      // home: const PhotoViewFutureBuilder(),
      //const PhotoView()
      // const ToDoApp(),
    );
  }
}
