abstract class Failure {
  // String description();
  String get description;
}

class FirebaseFailure extends Failure {
  final String message;

  FirebaseFailure(this.message);
  @override
  String get description => "Bir hata oluştu: $message";
}

class UnexpectedFailure extends Failure {
  final String message;
  UnexpectedFailure(this.message);
  @override
  String get description => "Beklenmedik bir hata ile karşılaşıldı: $message";
}
