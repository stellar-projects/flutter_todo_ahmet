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

import '../model/model_todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  List<TodoItem> items = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference<Map<String, dynamic>> db =
      FirebaseFirestore.instance.collection("todo");

  final storageRef = FirebaseStorage.instance.ref();

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
      storageRef.child("images/$uid/${items[event.index].id}.jpg").delete();
    }
    items.removeAt(event.index);
    emit(StateDidLoadItems(items));
    await db.doc(uid).collection("items").doc(event.id).delete();
  }

  Future<FutureOr<void>> _onTapAddNewRow(
      EventAddNewItem event, Emitter<TodoState> emit) async {
    final newDocRef = db.doc(uid).collection("items").doc();
    TodoItem todo = TodoItem(id: newDocRef.id.toString(), text: event.text);
    items.add(todo);
    newDocRef.set(todo.toMap());

    emit(StateDidLoadItems(items));
  }

  FutureOr<void> _onTapCheck(EventCheck event, Emitter<TodoState> emit) {
    event.item.isChecked = event.isChecked;
    final checkRef = db.doc(uid).collection("items").doc(event.item.id);
    checkRef.update({"isChecked": event.isChecked});

    emit(StateDidLoadItems(items));
  }

  FutureOr<void> _onTapTakePhotoWithCamera(
      EventTakePhotoWithCamera event, Emitter<TodoState> emit) async {
    ImagePicker image = ImagePicker();
    var img = await image.pickImage(source: ImageSource.camera);
    if (img != null) {
      final itemImageRef = storageRef.child("images/$uid/${event.item.id}.jpg");
      await itemImageRef.putFile(File(img.path));
      final imageUrl = await itemImageRef.getDownloadURL();
      event.item.itemUrl = imageUrl;
      final itemRef = db.doc(uid).collection("items").doc(event.item.id);
      itemRef.update({"itemImagePath": imageUrl});
    }
    emit(StateDidLoadItems(items));
  }

  FutureOr<void> _onTapSelectImageFromGallery(
      EventSelectImageFromGallery event, Emitter<TodoState> emit) async {
    ImagePicker image = ImagePicker();
    await image.pickImage(source: ImageSource.gallery).then((img) async {
      if (img != null) {
        final itemImageRef =
            storageRef.child("images/$uid/${event.item.id}.jpg");

        await itemImageRef.putFile(File(img.path));
        final imageUrl = await itemImageRef.getDownloadURL();
        event.item.itemUrl = imageUrl;

        final itemRef = db.doc(uid).collection("items").doc(event.item.id);
        itemRef.update({"itemImagePath": imageUrl});
      }
    }).catchError((error) {
      debugPrint("Hata: $error");
    }).whenComplete(() {});
    emit(StateDidLoadItems(items));
  }

  FutureOr<void> _onLoadItems(
      EventLoadItems event, Emitter<TodoState> emit) async {
    items = await injections<RepositoryTodo>().loadData();
    emit(StateDidLoadItems(items));
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
                  onPressed: (() {
                    event.item.text = text;
                    final updateRef =
                        db.doc(uid).collection("items").doc(event.item.id);
                    updateRef.update({"task": text});
                    Navigator.pop(context);

                    emit(StateDidLoadItems(items));
                  }),
                  child: const Text("Güncelle")),
            ],
          )),
    );
  }
}
