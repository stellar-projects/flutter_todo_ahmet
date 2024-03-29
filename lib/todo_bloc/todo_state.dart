part of 'todo_bloc.dart';

@immutable
abstract class TodoState {}

class TodoInitial extends TodoState {}

class StateDidLoadItems extends TodoState {
  final List<TodoItem> items;
  StateDidLoadItems(this.items);
}

class StateError extends TodoState {
  final Failure? failure;
  StateError(this.failure);
}
