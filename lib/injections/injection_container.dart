import 'package:get_it/get_it.dart';

import '../repository/implementation/repository_todo_impl.dart';
import '../repository/interface/repository_todo.dart';

var injections = GetIt.instance;

initializeInjections() {
  injections.registerSingleton<RepositoryTodo>(RepositoryTodoSharedPrefs());
}
