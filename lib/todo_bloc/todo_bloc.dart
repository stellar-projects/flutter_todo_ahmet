import 'dart:async';
import 'dart:io';

import 'package:app_todo/injections/injection_container.dart';
import 'package:app_todo/repository/interface/repository_todo.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../model/model_failure.dart';
import '../model/model_todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  List<TodoItem> items = [];

  String get uid => FirebaseAuth.instance.currentUser?.uid ?? "";

  final db = FirebaseFirestore.instance.collection("todo");

  final storageRef = FirebaseStorage.instance.ref();

  final RepositoryTodo _repositoryTodo = injections();

  TodoBloc() : super(TodoInitial()) {
    on<EventLoadItems>(_onLoadItems);
    on<EventDeleteItem>(_onTapDeleteRow);
    on<EventAddNewItem>(_onTapAddNewRow);
    on<EventCheck>(_onTapCheck);
    on<EventTakePhotoWithCamera>(_onTapTakePhotoWithCamera);
    on<EventSelectImageFromGallery>(_onTapSelectImageFromGallery);
    on<EventUpdate>(_onTapUpdateRow);
  }

  Future<FutureOr<void>> _onTapDeleteRow(
      EventDeleteItem event, Emitter<TodoState> emit) async {
    if (items[event.index].itemUrl != null) {
      // await FirebaseStorage.instance
      //     .refFromURL(items[event.index].itemUrl!)
      //     .delete();
      await _repositoryTodo
          .deleteFromStorage(event.id)
          .then((value) => value.fold((l) => null, (r) => emit(StateError(r))));
    }
    items.removeAt(event.index);
    await _repositoryTodo.delete(event.id).then((value) => value.fold(
        (l) => emit(StateDidLoadItems(items)), (r) => emit(StateError(r))));
  }

  Future<FutureOr<void>> _onTapAddNewRow(
      EventAddNewItem event, Emitter<TodoState> emit) async {
    final newDocRef = db.doc(uid).collection("items").doc();
    TodoItem item = TodoItem(id: newDocRef.id.toString(), text: event.text);
    items.add(item);

    await _repositoryTodo.add(item).then((value) {
      value.fold(
          (l) => emit(StateDidLoadItems(items)), (r) => emit(StateError(r)));
    });
  }

  FutureOr<void> _onTapCheck(EventCheck event, Emitter<TodoState> emit) async {
    event.item.isChecked = event.isChecked;
    await _repositoryTodo.update(event.item).then((value) => value.fold(
        (l) => emit(StateDidLoadItems(items)), (r) => emit(StateError(r))));
  }

  FutureOr<void> _onTapTakePhotoWithCamera(
      EventTakePhotoWithCamera event, Emitter<TodoState> emit) async {
    ImagePicker image = ImagePicker();

    await image
        .pickImage(source: ImageSource.camera, imageQuality: 80)
        .then((img) async {
      if (img != null) {
        await _repositoryTodo.addImage(event.item.id, img.path).then((value) {
          value.fold((l) => event.item.itemUrl = l, (r) => StateError(r));
        });

        await _repositoryTodo.update(event.item).then((value) => value.fold(
            (l) => emit(StateDidLoadItems(items)), (r) => emit(StateError(r))));
      }
    }).catchError((error) {
      emit(StateError(UnexpectedFailure(error.toString())));
    });
  }

  FutureOr<void> _onTapSelectImageFromGallery(
      EventSelectImageFromGallery event, Emitter<TodoState> emit) async {
    ImagePicker image = ImagePicker();
    await image
        .pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    )
        .then((img) async {
      if (img != null) {
        await _repositoryTodo.addImage(event.item.id, img.path).then((value) {
          value.fold((l) => event.item.itemUrl = l, (r) => StateError(r));
        });

        await _repositoryTodo.update(event.item).then((value) => value.fold(
            (l) => emit(StateDidLoadItems(items)), (r) => emit(StateError(r))));
      }
    }).catchError((error) {
      emit(StateError(UnexpectedFailure(error.toString())));
    });
  }

  FutureOr<void> _onLoadItems(
      EventLoadItems event, Emitter<TodoState> emit) async {
    await _repositoryTodo.loadItems().then((value) => value.fold((l) {
          items = l;
          emit(StateDidLoadItems(l));
        }, (r) => emit(StateError(r))));
  }

  FutureOr<void> _onTapUpdateRow(
      EventUpdate event, Emitter<TodoState> emit) async {
    String text = "";
    text = event.item.text;
    await showDialog(
      context: event.context,
      builder: ((context) => SimpleDialog(
            children: [
              TextFormField(
                onChanged: ((value) {
                  text = value;
                }),
                initialValue: event.item.text,
              ),
              ElevatedButton(
                  onPressed: (() async {
                    event.item.text = text;
                    await _repositoryTodo.update(event.item).then((value) =>
                        value.fold((l) => emit(StateDidLoadItems(items)),
                            (r) => emit(StateError(r))));
                    Navigator.pop(context);

                    emit(StateDidLoadItems(items));
                  }),
                  child: const Text("Güncelle")),
            ],
          )),
    );
  }
}
