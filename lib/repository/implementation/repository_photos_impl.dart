import 'dart:async';

import 'package:app_todo/model/model_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:app_todo/model/photos_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../interface/repository_photos.dart';

class RepositoryPhotosDio extends RepositoryPhotos {
  @override
  Future<Either<List<PhotosModel>, Failure?>> getPhotos() async {
    var completer = Completer<Either<List<PhotosModel>, Failure?>>();
    var dio = Dio();
    var apiKey = "MW6caIG6yo22-AqmbB0186KtLMChtHs3Lj0V8wozNoc";
    dio
        .get("https://api.unsplash.com/photos/?client_id=$apiKey")
        .then((response) {
      var parsedJson = response.data;
      List<PhotosModel> returnValue = <PhotosModel>[];
      if (parsedJson is List) {
        returnValue = parsedJson.map((e) => PhotosModel.fromJson(e)).toList();
      }
      // return left(listPhotos);
      completer.complete(Left(returnValue));
    }).catchError((error, stackTrace) {
      debugPrint("Error: $error");
      debugPrint("Stack: $stackTrace");
      if (error is DioError) {
        completer.complete(Right(NetworkFailure(
            "${error.response?.statusCode} - ${error.message}", error)));
      } else {
        completer.complete(Right(UnexpectedFailure("Beklenmedik hata", error)));
      }
    });

    return completer.future;

    // var response =
    //     await dio.get("https://api.unsplash.com/photos/?client_id=$apiKey");
    //
    // var parsedJson = response.data;
    //
    // if (response.statusCode == 200 && parsedJson is List) {
    //   print("list len ${parsedJson.length}");
    //   var listPhotos = parsedJson.map((e) => PhotosModel.fromJson(e)).toList();
    //   return left(listPhotos);
    // } else {
    //   return right("Hata var");
    // }

    // try {
    //   print("list len ${parsedJson.length}");
    //   var listPhotos = parsedJson.map((e) => PhotosModel.fromJson(e)).toList();
    //   return left(listPhotos);
    // } catch (e) {
    //   return right("Error Error Error");
    //   // return right(ModelFailure("Error Error"));
    // }
  }
}
