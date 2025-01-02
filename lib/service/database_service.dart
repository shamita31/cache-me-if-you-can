import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  late final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Future saveUserData(String fullname, String email, String password) async {
    return await userCollection
        .doc(uid)
        .set({"fullname": fullname, "email": email, "password": password});
  }

  //getter func for user data snapshot
  Future getUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }
}
