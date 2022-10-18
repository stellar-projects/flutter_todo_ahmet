part of 'photo_bloc.dart';

@immutable
abstract class PhotoEvent {}

class EventGetPhotos extends PhotoEvent {}

class EventDeletePhoto extends PhotoEvent {
  final List<PhotosModel> photos;
  EventDeletePhoto(this.photos);
}