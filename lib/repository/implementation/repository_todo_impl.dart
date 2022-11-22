import 'dart:async';
import 'dart:io';

import 'package:app_todo/model/model_failure.dart';
import 'package:app_todo/model/model_todo.dart';
import 'package:app_todo/repository/interface/repository_todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RepositoryTodoFirebase extends RepositoryTodo {
  var db = FirebaseFirestore.instance.collection("todo");
  String get uid => FirebaseAuth.instance.currentUser?.uid ?? "";
  final storageRef = FirebaseStorage.instance.ref();

  @override
  Future<Either<List<TodoItem>, Failure?>> loadItems() async {
    var completer = Completer<Either<List<TodoItem>, Failure?>>();

    await db.doc(uid).collection("items").get().then((snapshot) {
      List<TodoItem> returnValue = [];
      returnValue = snapshot.docs
          .map((docSnapshot) => TodoItem.fromDocumentSnapshot(docSnapshot))
          .toList();

      completer.complete(Left(returnValue));
    }).catchError((error) {
      if (error is FirebaseException) {
        completer.complete(Right(FirebaseFailure(error.message.toString())));
      } else {
        completer.complete(Right(UnexpectedFailure(error.toString())));
      }
    });
    return completer.future;
  }

  @override
  Future<Either<void, Failure?>> add(TodoItem item) async {
    var completer = Completer<Either<void, Failure?>>();
    await db
        .doc(uid)
        .collection("items")
        .doc(item.id)
        .set(item.toMap())
        .then((value) {
      completer.complete(const Left(null));
    }).catchError((error) {
      if (error is FirebaseException) {
        completer.complete(Right(FirebaseFailure(error.message.toString())));
      } else {
        completer.complete(Right(UnexpectedFailure(error.toString())));
      }
    });
    return completer.future;
  }

  @override
  Future<Either<void, Failure?>> delete(String docId) {
    var completer = Completer<Either<void, Failure?>>();

    db.doc(uid).collection("items").doc(docId).delete().then((value) {
      completer.complete(const Left(null));
    }).catchError((error) {
      if (error is FirebaseException) {
        completer.complete(Right(FirebaseFailure(error.message.toString())));
      } else {
        completer.complete(Right(UnexpectedFailure(error.toString())));
      }
    });
    return completer.future;
  }

  @override
  Future<Either<void, Failure?>> deleteFromStorage(String docId) {
    var completer = Completer<Either<void, Failure?>>();
    storageRef
        .child("images/$uid/$docId.jpg")
        .delete()
        .then((value) => completer.complete(const Left(null)))
        .catchError((error) {
      if (error is FirebaseException) {
        completer.complete(Right(FirebaseFailure(error.message.toString())));
      } else {
        completer.complete(Right(UnexpectedFailure(error.toString())));
      }
    });
    return completer.future;
  }

  @override
  Future<Either<String, Failure?>> addImage(
      String docId, String localFileUrl) async {
    var completer = Completer<Either<String, Failure?>>();

    await storageRef
        .child("images/$uid/$docId.jpg")
        .putFile(File(localFileUrl))
        .then((value) async {
      var imageUrl =
          await storageRef.child("images/$uid/$docId.jpg").getDownloadURL();
      completer.complete(Left(imageUrl));
    }).catchError((error) {
      if (error is FirebaseException) {
        completer.complete(Right(FirebaseFailure(error.message.toString())));
      } else {
        completer.complete(Right(UnexpectedFailure(error.toString())));
      }
    });
    return completer.future;
  }

  @override
  Future<Either<void, Failure?>> update(TodoItem item) async {
    var completer = Completer<Either<void, Failure?>>();
    await db
        .doc(uid)
        .collection("items")
        .doc(item.id)
        .update({
          "task": item.text,
          "isChecked": item.isChecked,
          "itemImagePath": item.itemUrl
        })
        .then((value) => completer.complete(const Left(null)))
        .catchError((error) {
          if (error is FirebaseException) {
            completer
                .complete(Right(FirebaseFailure(error.message.toString())));
          } else {
            completer.complete(Right(UnexpectedFailure(error.toString())));
          }
        });

    return completer.future;
  }
}
