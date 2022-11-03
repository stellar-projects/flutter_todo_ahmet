part of 'photo_bloc.dart';

abstract class PhotoState {}

class PhotoInitial extends PhotoState {}

class StateDidReceivePhotos extends PhotoState {
  final List<PhotosModel> photos;
  StateDidReceivePhotos(this.photos);
}

class StateLoading extends PhotoState {}

class StatePhotosFailure extends PhotoState {
  final Failure? failure;
  StatePhotosFailure(this.failure);
}
