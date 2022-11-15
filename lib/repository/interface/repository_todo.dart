import 'package:app_todo/model/model_todo.dart';

abstract class RepositoryTodo {
  Future<List<TodoItem>> loadData();
}
