import 'dart:async';

import 'package:app_todo/injections/injection_container.dart';
import 'package:app_todo/model/photos_model.dart';
import 'package:app_todo/repository/implementation/repository_photos_impl.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../repository/interface/repository_photos.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  PhotoBloc() : super(PhotoInitial()) {
    on<EventGetPhotos>(_onGetPhotos);
  }

  final RepositoryPhotos _repositoryPhotos = RepositoryPhotosDio();

  FutureOr<void> _onGetPhotos(
      EventGetPhotos event, Emitter<PhotoState> emit) async {
    emit(StateLoading());
    await Future.delayed(const Duration(seconds: 5));

    // await _repositoryPhotos.getPhotos().then((value) => value.fold(
    //     (l) => emit(StateDidReceivePhotos(l)),
    //     (r) => emit(StatePhotosFailure(r))));

    await injections<RepositoryPhotos>().getPhotos().then((value) => value.fold(
        (l) => emit(StateDidReceivePhotos(l)),
        (r) => emit(StatePhotosFailure(r))));
  }
}
