import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usermodels.dart';

class UserService {
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection('users');

  Future<void> addUser(UserModel user) async {
    try {
      await userCollection.doc(user.id).set(user.toMap());
    } catch (e) {
      throw Exception("Error adding user: $e");
    }
  }

  Stream<List<UserModel>> getUsers() {
    return userCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>)).toList());
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await userCollection.doc(user.id).update(user.toMap());
    } catch (e) {
      throw Exception("Error updating user: $e");
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await userCollection.doc(id).delete();
    } catch (e) {
      throw Exception("Error deleting user: $e");
    }
  }
}
