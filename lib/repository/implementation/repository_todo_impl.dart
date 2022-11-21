import 'package:app_todo/model/model_failure.dart';
import 'package:app_todo/model/model_todo.dart';
import 'package:app_todo/repository/interface/repository_todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RepositoryTodoFireStore extends RepositoryTodo {
  @override
  Future<List<TodoItem>> loadData() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await db.collection("todo").doc(uid).collection("items").get();
    return snapshot.docs
        .map((docSnapshot) => TodoItem.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

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
