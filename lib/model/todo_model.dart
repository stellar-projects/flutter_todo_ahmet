import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TodoItem {
  String? id;
  String text;
  bool isChecked;
  //File? file;
  TodoItem({this.id, required this.text, required this.isChecked});

  // Map<String, dynamic> toJson() {
  //   return {"text": text, "isChecked": isChecked, "file": file?.path};
  // }

  // static TodoItem fromJson(Map<String, dynamic> json) {
  //   return TodoItem(json["text"], json["isChecked"],
  //       json["file"] == null ? null : File(json["file"]));
  // }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "task": text,
      "isChecked": isChecked,
    };
  }

  factory TodoItem.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return TodoItem(
        id: doc.id,
        text: doc.data()!["task"],
        isChecked: doc.data()!["isChecked"]);
  }
}
