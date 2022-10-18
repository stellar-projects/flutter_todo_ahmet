part of 'todo_bloc.dart';

@immutable
abstract class TodoState {}

class TodoInitial extends TodoState {}

class StateDeleteItem extends TodoState {
  final List<TodoItem> items;
  StateDeleteItem(this.items);
}

class StateAddItem extends TodoState {
  final List<TodoItem> items;
  StateAddItem(this.items);
}

class StateIsChecked extends TodoState {
  final TodoItem item;
  StateIsChecked(this.item);
}

class StateTakePhotoWithCamera extends TodoState {
  final TodoItem item;
  StateTakePhotoWithCamera(this.item);
}

class StateSelectImageFromGallery extends TodoState {
  final TodoItem item;
  StateSelectImageFromGallery(this.item);
}

class StateDidLoadItems extends TodoState{
  final List<TodoItem> items;
  StateDidLoadItems(this.items);
}