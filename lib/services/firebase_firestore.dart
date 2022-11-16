import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  Future addUser(User? user) async {
    var userDocument =
        FirebaseFirestore.instance.collection("users").doc(user?.uid);

    Map<String, dynamic> userDetail = {
      "sonGirisTarihi": FieldValue.serverTimestamp(),
      "email": user?.email ?? "",
      "displayName": user?.displayName ?? "",
      "photoUrl": user?.photoURL ?? "",
    };

    userDocument.set(userDetail);
  }
}
