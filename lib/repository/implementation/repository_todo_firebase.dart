import 'package:app_todo/model/model_failure.dart';
import 'package:app_todo/model/model_todo.dart';
import 'package:app_todo/repository/interface/repository_todo.dart';
import 'package:dartz/dartz.dart';

class RepositoryTodoFirebase extends RepositoryTodo{
  @override
  Future<Either<void, Failure?>> add(TodoItem item) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<Either<String, Failure?>> addImage(String uid, String localFileUrl) {
    // TODO: implement addImage
    throw UnimplementedError();
  }

  @override
  Future<Either<void, Failure?>> delete(String uid) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<TodoItem>> loadData() {
    // TODO: implement loadData
    throw UnimplementedError();
  }

  @override
  Future<Either<List<TodoItem>, Failure?>> loadItems() {
    // TODO: implement loadItems
    throw UnimplementedError();
  }

  @override
  Future<Either<void, Failure?>> update(TodoItem item) {
    // TODO: implement update
    throw UnimplementedError();
  }
  
}