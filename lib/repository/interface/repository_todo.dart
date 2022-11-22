import 'package:app_todo/model/model_failure.dart';
import 'package:app_todo/model/model_todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class RepositoryTodo {
  //Firebase ile ekleyeceğimiz çağrılar
  Future<Either<List<TodoItem>, Failure?>> loadItems();
  Future<Either<void, Failure?>> delete(String docId);
  Future<Either<void, Failure?>> deleteFromStorage(String docId);
  Future<Either<void, Failure?>> add(TodoItem item);
  Future<Either<void, Failure?>> update(TodoItem item);
  Future<Either<String, Failure?>> addImage(String docId, String localFileUrl);
}
