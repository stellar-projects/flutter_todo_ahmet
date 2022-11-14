part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent {}

class EventLoadItems extends TodoEvent {}

class EventDeleteItem extends TodoEvent {
  final int index;
  final String id;
  EventDeleteItem(this.index, this.id);
}

class EventAddNewItem extends TodoEvent {
  //final List<TodoItem> items;
  final String text;
  EventAddNewItem(this.text);
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

class EventUpdate extends TodoEvent {
  final TodoItem item;
  final BuildContext context;
  EventUpdate(this.item, this.context);
}
