import 'package:app_todo/model/model_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:app_todo/model/photos_model.dart';
import 'package:dio/dio.dart';
import '../interface/repository_photos.dart';

class RepositoryPhotosDio extends RepositoryPhotos {
  @override
  Future<Either<List<PhotosModel>, dynamic>> getPhotos() async {
    var dio = Dio();

    var apiKey = "MW6caIG6yo22-AqmbB0186KtLMChtHs3Lj0V8wozNoc";
    var response =
        await dio.get("https://api.unsplash.com/photos/?client_id=$apiKey");

    var parsedJson = response.data;

    if (response.statusCode == 200 && parsedJson is List) {
      print("list len ${parsedJson.length}");
      var listPhotos = parsedJson.map((e) => PhotosModel.fromJson(e)).toList();
      return left(listPhotos);
    } else {
      return right("Hata var");
    }

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
