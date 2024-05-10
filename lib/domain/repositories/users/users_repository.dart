import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show User;

class UsersRepository {
  static final UsersRepository instance = UsersRepository._internal();

  factory UsersRepository() => instance;

  UsersRepository._internal();

  final CollectionReference _userCollection =
  FirebaseFirestore.instance.collection('users');

  Future<User?> getUserById(String userId) async {
    try {
      final DocumentSnapshot doc =
      await _userCollection.doc(userId).get();

      if (doc.exists) {
        final data = doc.data()! as Map<String, dynamic>;

        data['createdAt'] = data['createdAt']?.millisecondsSinceEpoch;
        data['id'] = doc.id;
        data['lastSeen'] = data['lastSeen']?.millisecondsSinceEpoch;
        data['updatedAt'] = data['updatedAt']?.millisecondsSinceEpoch;
        final user = User.fromJson(data);
        return user;
      } else {
        return null; // User with the provided ID doesn't exist
      }
    } catch (e) {
      print('Error retrieving user: $e');
      return null; // Error occurred while retrieving the user
    }
  }
}