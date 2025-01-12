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

  //task add
  Future addTask(Map<String, dynamic> userMap, String id) async {
    await FirebaseFirestore.instance.collection("Tasks").doc(id).set(userMap);
  }

  //getter fn for task
  Future<Stream<QuerySnapshot>> getTask(String taskCollection) async {
    return await FirebaseFirestore.instance.collection(taskCollection).snapshots();
  }


  //deleting task from firebasestore once its completed
  Future<void> completeAndRemoveTask(String id, String taskCollection) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  return firestore.runTransaction((transaction) async {
    DocumentReference taskRef = firestore.collection(taskCollection).doc(id);

    // Retrieve the task document
    DocumentSnapshot taskSnapshot = await transaction.get(taskRef);

    if (!taskSnapshot.exists) {
      throw Exception("Task does not exist!");
    }

    // Mark the task as completed (you can modify the fields as needed)
    transaction.update(taskRef, {"Completed": true});

    // Delete the task after marking it as completed
    transaction.delete(taskRef);
  });
}
}
