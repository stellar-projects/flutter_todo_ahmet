import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class TodoItem {
  String id;
  String text;
  bool isChecked;
  String? itemUrl;
  TodoItem(
      {required this.id,
      required this.text,
      this.isChecked = false,
      this.itemUrl});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "task": text,
      "isChecked": isChecked,
      "itemImagePath": itemUrl
    };
  }

  factory TodoItem.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return TodoItem(
        id: doc.id,
        text: doc.data()!["task"],
        isChecked: doc.data()!["isChecked"],
        itemUrl: doc.data()?["itemImagePath"] ?? "");
  }
}
