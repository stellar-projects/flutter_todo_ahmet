import 'package:cloud_firestore/cloud_firestore.dart';

class TodoItem {
  String? id;
  String text;
  bool isChecked;
  //File? file;
  TodoItem({required this.id, required this.text, this.isChecked = false});

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
