import 'dart:convert';

import 'package:app_todo/model/todo_model.dart';
import 'package:app_todo/repository/interface/repository_todo.dart';
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
        return todoItems.map((e) => TodoItem.fromJson(e)).toList();
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
