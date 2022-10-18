import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../todo_model.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {

  List<TodoItem> items = [];

  TodoBloc() : super(TodoInitial()) {
    on<EventLoadItems>(_onLoadItems);
    on<EventDeleteItem>(_onTapDeleteRow);
    on<EventAddNewItem>(_onTapAddNewRow);
    on<EventCheck>(_onTapCheck);
    on<EventTakePhotoWithCamera>(_onTapTakePhotoWithCamera);
    on<EventSelectImageFromGallery>(_onTapSelectImageFromGallery);
  }

  FutureOr<void> _onTapDeleteRow(
      EventDeleteItem event, Emitter<TodoState> emit) {
    event.items.removeAt(event.index);
    emit(StateDeleteItem(event.items));
  }

  FutureOr<void> _onTapAddNewRow(EventAddNewItem event, Emitter<TodoState> emit) {
    items.add(TodoItem(event.text, false, null));
    emit(StateDidLoadItems(items));
  }

  FutureOr<void> _onTapCheck(EventCheck event, Emitter<TodoState> emit) {
    event.item.isChecked = event.isChecked;
    // emit(StateIsChecked(event.item));
    emit(StateDidLoadItems(items));
  }

  FutureOr<void> _onTapTakePhotoWithCamera(
      EventTakePhotoWithCamera event, Emitter<TodoState> emit) async {
    ImagePicker image = ImagePicker();
    var img = await image.pickImage(source: ImageSource.camera);
    if (img != null) {
      event.item.file = File(img.path);
    }
    emit(StateTakePhotoWithCamera(event.item));
  }

  FutureOr<void> _onTapSelectImageFromGallery(
      EventSelectImageFromGallery event, Emitter<TodoState> emit) async {
    ImagePicker image = ImagePicker();

    await image.pickImage(source: ImageSource.gallery).then((img) {
      if (img != null) {
        event.item.file = File(img.path);
      }
    }).catchError((error) {
      debugPrint("Hata: $error");
    }).whenComplete(() {
      emit(StateSelectImageFromGallery(event.item));
    });
    emit(StateDidLoadItems(items));
    // var img = await image.pickImage(source: ImageSource.gallery);
    // if (img != null) {
    //   event.item.file = File(img.path);
    // } else {
    //   event.item.file = null;
    // }
    // emit(StateSelectImageFromGallery(event.item));
  }

  void _savePrefs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String json = jsonEncode(items);
    print("***SAVE***");
    sharedPreferences.setString("todo", json);
  }

  FutureOr<void> _onLoadItems(EventLoadItems event, Emitter<TodoState> emit) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var todoString = sharedPreferences.get("todo");

    if (todoString is String) {
      var todoItems = jsonDecode(todoString);
      if (todoItems is List) {
        items = todoItems.map((e) => TodoItem.fromJson(e)).toList();
      }
    }
    emit(StateDidLoadItems(items));
  }
}
