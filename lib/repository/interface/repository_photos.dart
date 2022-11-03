import 'package:app_todo/model/model_failure.dart';
import 'package:app_todo/model/photos_model.dart';
import 'package:dartz/dartz.dart';

abstract class RepositoryPhotos {
  //TODO 1- Photos Implementastonu
  //TODO 2- dynamic olan kısım için bir Failure modeli
  //TODO 3- photos bu repository'i photos bloc içine entegre etmen gerekiyor
  //TODO 4- photos bloc'da hata durumunda failure state'i dönmeli
  //TODO 5- Hata olması durumunda alert ile hata mesajı gösterilsin
  Future<Either<List<PhotosModel>, Failure?>> getPhotos();
}
