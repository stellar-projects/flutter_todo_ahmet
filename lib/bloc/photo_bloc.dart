import 'dart:async';

import 'package:app_todo/model/photos_model.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  PhotoBloc() : super(PhotoInitial()) {
    on<EventGetPhotos>(_onGetPhotos);
    on<EventDeletePhoto>(_deletePhoto);
  }

  FutureOr<void> _onGetPhotos(
      EventGetPhotos event, Emitter<PhotoState> emit) async {
    emit(StateLoading());
    await Future.delayed(const Duration(seconds: 5));

    var dio = Dio();

    var apiKey = "MW6caIG6yo22-AqmbB0186KtLMChtHs3Lj0V8wozNoc";
    var response = await dio
        .get("https://api.unsplash.com/photos/?client_id=$apiKey&page=2");

    /*var x =
        await dio.post("https://api.unsplash.com/photos/?client_id=$apiKey",
                  data:
        );*/

    // jsonDecode == response.data diyebilir miyiz?
    // Çünkü sharedPrefs'de get ile aldığımız veriyi jsonDecode ile anlamlı hale getiriyorduk.
    // Api üzerinden gelen veriyi ise direkt response.data ile anlamlı hale getiriyoruz.

    var parsedJson = response.data;
    if (response.statusCode == 200) {
      if (parsedJson is List) {
        print("list len ${parsedJson.length}");
        emit(StateDidReceivePhotos(
            parsedJson.map((e) => PhotosModel.fromJson(e)).toList()));
      }
      /*parsedJson.forEach((elm) {
        photos.add(PhotosModel.fromJson(elm));
      });*/
    } else {
      emit(StateDidReceivePhotos(const []));
    }
  }

  FutureOr<void> _deletePhoto(
      EventDeletePhoto event, Emitter<PhotoState> emit) {
    event.photos.removeLast();

    emit(StateDeletedPhoto(event.photos));
  }
}
