part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent {}

class EventDeleteItem extends TodoEvent {
  final List<TodoItem> items;
  final int index;
  EventDeleteItem(this.items, this.index);
}

class EventAddNewItem extends TodoEvent {
  final List<TodoItem> items;
  final String text;
  EventAddNewItem(this.items, this.text);
}

class EventCheck extends TodoEvent {
  final TodoItem item;
  final bool isChecked;
  EventCheck(this.item, this.isChecked);
}

class EventTakePhotoWithCamera extends TodoEvent {
  final TodoItem item;
  EventTakePhotoWithCamera(this.item);
}

class EventSelectImageFromGallery extends TodoEvent {
  final TodoItem item;
  EventSelectImageFromGallery(this.item);
}

//Update kısmı kaldı
