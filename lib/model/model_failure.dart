import 'package:dio/dio.dart';

abstract class Failure {
  String get description;
}

class NetworkFailure extends Failure {
  final String message;
  final DioError error;
  NetworkFailure(this.message, this.error);

  @override
  String get description => "Network katmanında hata oluştu: $message";

  // @override
  // String toString() => message;
}

class UnexpectedFailure extends Failure {
  final String message;
  final dynamic error;

  UnexpectedFailure(this.message, this.error);

  @override
  String get description =>
      "Beklenmedik bir hata ile karşılaşıldı: $message\n\n$error";
}
