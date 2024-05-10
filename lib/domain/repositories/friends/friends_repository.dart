import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/dtos/friend/friend.dart';

class FriendRepository {
  FriendRepository._privateConstructor();

  static final FriendRepository _instance = FriendRepository._privateConstructor();

  static FriendRepository get instance => _instance;

  final CollectionReference _friendCollection = FirebaseFirestore.instance.collection('friends');

  Future<void> addFriend(Friend friend) => _friendCollection.doc(friend.id).set(friend.toJson());

  Future<List<Friend>> getListWaitedAccepted(String userId) => _friendCollection
      .where('targetId', isEqualTo: userId)
      .where('isTargetAccepted', isEqualTo: 'waiting')
      .get()
      .then((snapshot) => snapshot.docs
      .map((doc) => Friend.fromJson(doc.data() as Map<String, dynamic>))
      .toList());

  Future<void> acceptFriend(String friendId) => _friendCollection.doc(friendId).update({
    'isTargetAccepted': true,
    'updatedAt': DateTime.now(),
  });

  Future<List<Friend>> getSendFriendRequestList(String userId) => _friendCollection
      .where('authorId', isEqualTo: userId)
      .where('isTargetAccepted', isEqualTo: false)
      .get()
      .then((snapshot) => snapshot.docs
      .map((doc) => Friend.fromJson(doc.data() as Map<String, dynamic>))
      .toList());

  Future<void> deleteFriend(String friendId) => _friendCollection.doc(friendId).delete();

  Future<List<Friend>> getAcceptedFriends(String userId) async {
    final authorFriends = await _getFriends(userId, 'authorId');
    final targetFriends = await _getFriends(userId, 'targetId');
    return [...authorFriends, ...targetFriends];
  }

  Future<List<Friend>> _getFriends(String userId, String field) => _friendCollection
      .where(field, isEqualTo: userId)
      .where('isTargetAccepted', isEqualTo: true)
      .get()
      .then((snapshot) => snapshot.docs
      .map((doc) => Friend.fromJson(doc.data() as Map<String, dynamic>))
      .toList());

  Future<Friend?> getFriend(String userId, String otherUserId) async {
    final snapshot = await _friendCollection
        .where('authorId', isEqualTo: userId)
        .where('targetId', isEqualTo: otherUserId)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return Friend.fromJson(snapshot.docs.first.data() as Map<String, dynamic>);
  }
}