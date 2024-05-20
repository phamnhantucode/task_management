import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/dtos/user/user_dto.dart';

class UsersRepository {
  static final UsersRepository instance = UsersRepository._internal();

  factory UsersRepository() => instance;

  UsersRepository._internal();

  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<UserDto?> getUserById(String userId) async {
    try {
      final doc = await _userCollection.doc(userId).get();
      if (!doc.exists) {
        return null;
      }
      final data = doc.data()! as Map<String, dynamic>;
      return UserDto.fromJson(data);
    } catch (e) {
      print('Error retrieving user: $e');
      return null; // Error occurred while retrieving the user
    }
  }

  Future<List<UserDto>> getUsersById(List<String> userIds) async {
    try {
      final List<DocumentSnapshot> docs = await Future.wait(
        userIds.map((userId) => _userCollection.doc(userId).get()),
      );

      final users = docs.where((doc) => doc.exists).map((doc) {
        final data = doc.data()! as Map<String, dynamic>;
        return UserDto.fromJson(data);
      }).toList();

      return users;
    } catch (e) {
      print('Error retrieving users: $e');
      return []; // Error occurred while retrieving the users
    }
  }

  //update imageUrl
  Future<void> updateUserImageUrl(String userId, String imageUrl) async {
    try {
      await _userCollection.doc(userId).update({
        'imageUrl': imageUrl,
      });
    } catch (e) {
      print('Error updating user image URL: $e');
    }
  }

  Future<void> updateUser(UserDto userDto) {
    return _userCollection.doc(userDto.id).set(userDto.toJson());
  }

  Future<void> updateUserNotificationToken(
      String userId, String notificationToken) async {
    try {
      await _userCollection.doc(userId).update({
        'notificationToken': notificationToken,
      });
    } catch (e) {
      print('Error updating user notification token: $e');
    }
  }

  //update firstname
  Future<void> updateUserFirstName(String userId, String firstName) async {
    try {
      await _userCollection.doc(userId).update({
        'firstName': firstName,
      });
    } catch (e) {
      print('Error updating user first name: $e');
    }
  }

  //update id
  Future<void> updateUserId(String userId) async {
    try {
      await _userCollection.doc(userId).update({
        'id': userId,
      });
    } catch (e) {
      print('Error updating user first name: $e');
    }
  }
}
