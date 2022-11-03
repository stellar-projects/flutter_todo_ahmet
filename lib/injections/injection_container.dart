import 'package:app_todo/repository/implementation/repository_photos_impl.dart';
import 'package:app_todo/repository/interface/repository_photos.dart';
import 'package:get_it/get_it.dart';

import '../repository/implementation/repository_todo_impl.dart';
import '../repository/interface/repository_todo.dart';

var injections = GetIt.instance;

initializeInjections() {
  // injections.registerSingleton<RepositoryTodo>(RepositoryTodoSharedPrefs());
  injections
      .registerLazySingleton<RepositoryTodo>(() => RepositoryTodoSharedPrefs());

  injections.registerSingleton<RepositoryPhotos>(RepositoryPhotosDio());
}
