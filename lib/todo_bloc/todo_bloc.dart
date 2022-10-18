import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../todo_model.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
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

  FutureOr<void> _onTapAddNewRow(
      EventAddNewItem event, Emitter<TodoState> emit) {
    event.items.add(TodoItem(event.text, false, null));
    emit(StateAddItem(event.items));
  }

  FutureOr<void> _onTapCheck(EventCheck event, Emitter<TodoState> emit) {
    event.item.isChecked = event.isChecked;
    emit(StateIsChecked(event.item));
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

    /*image.pickImage(source: ImageSource.gallery).then((img) {
      if (img != null) {
        event.item.file = File(img.path);
      }
    }).catchError((error) {
      debugPrint("Hata: $error");
    }).whenComplete(() {
      emit(StateSelectImageFromGallery(event.item));
    });*/

    var img = await image.pickImage(source: ImageSource.gallery);
    if (img != null) {
      event.item.file = File(img.path);
    } else {
      event.item.file = null;
    }
    emit(StateSelectImageFromGallery(event.item));
  }
}
