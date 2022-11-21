import 'package:app_todo/model/model_failure.dart';
import 'package:app_todo/model/model_todo.dart';
import 'package:dartz/dartz.dart';

abstract class RepositoryTodo {
  Future<List<TodoItem>> loadData();

  //Firebase ile ekleyeceğimiz çağrılar
  Future<Either<List<TodoItem>,Failure?>> loadItems();
  Future<Either<void,Failure?>> delete(String uid);
  Future<Either<void, Failure?>> add(TodoItem item);
  Future<Either<void, Failure?>> update(TodoItem item);
  Future<Either<String, Failure?>> addImage(String uid,String localFileUrl);

}
