import 'package:app_todo/model/todo_model.dart';

abstract class RepositoryTodo{
 void saveData(List<TodoItem> items);
 Future<List<TodoItem>> loadData();
}