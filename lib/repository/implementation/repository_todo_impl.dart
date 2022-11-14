import 'dart:convert';

import 'package:app_todo/model/todo_model.dart';
import 'package:app_todo/repository/interface/repository_todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepositoryTodoSharedPrefs extends RepositoryTodo {
  //final Dio _dio;

  @override
  Future<List<TodoItem>> loadData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var todoString = sharedPreferences.get("todo");

    if (todoString is String) {
      var todoItems = jsonDecode(todoString);
      if (todoItems is List) {
        //return todoItems.map((e) => TodoItem.fromJson(e)).toList();
      }
    }
    return [];
  }

  @override
  void saveData(List<TodoItem> items) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String json = jsonEncode(items);
    print("***SAVE***");
    sharedPreferences.setString("todo", json);
  }
}

/// 1- TODO listesi elemnanları '/todo/{user_id}/... path'ine ekleniyor  ve okunuyor olucak
/// 2- TODO nesnen {"items":[TodoItem]}
class RepositoryTodoFireStore extends RepositoryTodo {
  @override
  Future<List<TodoItem>> loadData() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    String uid = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await db.collection("todo").doc(uid).collection("items").get();
    return snapshot.docs
        .map((docSnapshot) => TodoItem.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  @override
  void saveData(List<TodoItem> items) {
    // TODO: implement saveData
  }
}
