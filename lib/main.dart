import 'package:app_todo/screens/home_page.dart';
import 'package:app_todo/screens/photos_futurebuilder.dart';
import 'package:app_todo/screens/photos_with_bloc.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: //const ScreenPhotosWithBloc(),
          // home: const PhotoViewFutureBuilder(),
          //const PhotoView()
          const ToDoApp(),
    );
  }
}
