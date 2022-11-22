abstract class Failure {
  // String description();
  String get description;
}

class FirebaseFailure extends Failure {
  final String message;
  //final dynamic error;

  FirebaseFailure(this.message);
  @override
  String get description => "Bir hata oluştu: $message";
}

class UnexpectedFailure extends Failure {
  final String message;
  //final dynamic error;
  UnexpectedFailure(this.message);
  @override
  String get description => "Beklenmedik bir hata ile karşılaşıldı: $message";
}
