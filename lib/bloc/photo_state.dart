part of 'photo_bloc.dart';

@immutable
abstract class PhotoState {}

class PhotoInitial extends PhotoState {}

class StateDidReceivePhotos extends PhotoState {
  final List<PhotosModel> photos;
  StateDidReceivePhotos(this.photos);
}

class StateLoading extends PhotoState {}

class StateDeletedPhoto extends PhotoState {
  final List<PhotosModel> photos;
  StateDeletedPhoto(this.photos);
}
