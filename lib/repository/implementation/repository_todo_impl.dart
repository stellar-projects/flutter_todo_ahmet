import 'package:app_todo/model/todo_model.dart';
import 'package:app_todo/repository/interface/repository_todo.dart';

class RepositoryTodoSharedPrefs extends RepositoryTodo{

  @override
  Future<List<TodoItem>> loadData() {
    // TODO: implement loadData
    throw UnimplementedError();
  }

  @override
  void saveData(List<TodoItem> items) {
    // TODO: implement saveData
  }
}
