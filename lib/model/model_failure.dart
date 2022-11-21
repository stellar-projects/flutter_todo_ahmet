abstract class Failure{
  String description();
}

class FirebaseFailure{
  dynamic firebaseError;
  FirebaseFailure(this.firebaseError);
}