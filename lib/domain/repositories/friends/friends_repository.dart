import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import '../../../models/domain/friend/friend.dart';
import '../../../models/dtos/friend/friend.dart';
import '../../../models/dtos/user/user_dto.dart';
import '../users/users_repository.dart';

class FriendRepository {
  FriendRepository._privateConstructor();

  static final FriendRepository _instance = FriendRepository._privateConstructor();

  static FriendRepository get instance => _instance;

  final CollectionReference _friendCollection = FirebaseFirestore.instance.collection('friends');

  Future<void> addFriend(FriendDto friend) => _friendCollection.doc(friend.id).set(friend.toJson());

  Future<List<Friend>> getListWaitedAccepted(String userId) => _friendCollection
      .where('targetId', isEqualTo: userId)
      .where('isTargetAccepted', isEqualTo: false)
      .get()
      .then((snapshot) async => Future.wait(snapshot.docs.map((doc) async {
    final friendDto = FriendDto.fromJson(doc.data() as Map<String, dynamic>);
    final authorUser = await UsersRepository.instance.getUserById(friendDto.authorId);
    final targetUser = await UsersRepository.instance.getUserById(friendDto.targetId);

    return Friend.fromFriendDto(friendDto, authorUser!, targetUser!);
  })));

  Future<void> acceptFriend(String friendId) => _friendCollection.doc(friendId).update({
    'isTargetAccepted': true,
    'updatedAt': DateTime.now().toIso8601String(),
  });

  Future<List<Friend>> getSendFriendRequestList(String userId) => _friendCollection
      .where('authorId', isEqualTo: userId)
      .where('isTargetAccepted', isEqualTo: false)
      .get()
      .then((snapshot) async => Future.wait(snapshot.docs.map((doc) async {
    final friendDto = FriendDto.fromJson(doc.data() as Map<String, dynamic>);
    final authorUser = await UsersRepository.instance.getUserById(friendDto.authorId);
    final targetUser = await UsersRepository.instance.getUserById(friendDto.targetId);
    return Friend.fromFriendDto(friendDto, authorUser!, targetUser!);
  })));

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
      .then((snapshot) async => Future.wait(snapshot.docs.map((doc) async {
    final friendDto = FriendDto.fromJson(doc.data() as Map<String, dynamic>);
    final authorUser = await UsersRepository.instance.getUserById(friendDto.authorId);
    final targetUser = await UsersRepository.instance.getUserById(friendDto.targetId);
    return Friend.fromFriendDto(friendDto, authorUser!, targetUser!);
  })));

  Future<Friend?> getFriend(String userId, String otherUserId) async {
    final snapshot = await _friendCollection
        .where('authorId', isEqualTo: userId)
        .where('targetId', isEqualTo: otherUserId)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final friendDto = FriendDto.fromJson(snapshot.docs.first.data() as Map<String, dynamic>);
    final authorUser = await UsersRepository.instance.getUserById(friendDto.authorId);
    final targetUser = await UsersRepository.instance.getUserById(friendDto.targetId);

    if (authorUser == null || targetUser == null) {
      return null;
    }

    return Friend.fromFriendDto(friendDto, authorUser, targetUser);
  }

  Stream<List<Friend>> getListWaitedAcceptedStream(String userId) {
    return _friendCollection
        .where('targetId', isEqualTo: userId)
        .where('isTargetAccepted', isEqualTo: false)
        .snapshots()
        .asyncMap((snapshot) => Future.wait(snapshot.docs.map((doc) async {
      final friendDto = FriendDto.fromJson(doc.data() as Map<String, dynamic>);
      final authorUser = await UsersRepository.instance.getUserById(friendDto.authorId);
      final targetUser = await UsersRepository.instance.getUserById(friendDto.targetId);
      return Friend.fromFriendDto(friendDto, authorUser!, targetUser!);
    })));
  }

  Stream<List<Friend>> getSendFriendRequestListStream(String userId) {
    return _friendCollection
        .where('authorId', isEqualTo: userId)
        .where('isTargetAccepted', isEqualTo: false)
        .snapshots()
        .asyncMap((snapshot) => Future.wait(snapshot.docs.map((doc) async {
      final friendDto = FriendDto.fromJson(doc.data() as Map<String, dynamic>);
      final authorUser = await UsersRepository.instance.getUserById(friendDto.authorId);
      final targetUser = await UsersRepository.instance.getUserById(friendDto.targetId);
      return Friend.fromFriendDto(friendDto, authorUser!, targetUser!);
    })));
  }

  Stream<List<Friend>> getAcceptedFriendsStream(String userId) {
    final authorStream = _friendCollection
        .where('isTargetAccepted', isEqualTo: true)
        .where('authorId', isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot) => Future.wait(snapshot.docs.map((doc) async {
      final friendDto = FriendDto.fromJson(doc.data() as Map<String, dynamic>);
      final authorUser = await UsersRepository.instance.getUserById(friendDto.authorId);
      final targetUser = await UsersRepository.instance.getUserById(friendDto.targetId);
      return Friend.fromFriendDto(friendDto, authorUser!, targetUser!);
    })));

    final targetStream = _friendCollection
        .where('isTargetAccepted', isEqualTo: true)
        .where('targetId', isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot) => Future.wait(snapshot.docs.map((doc) async {
      final friendDto = FriendDto.fromJson(doc.data() as Map<String, dynamic>);
      final authorUser = await UsersRepository.instance.getUserById(friendDto.authorId);
      final targetUser = await UsersRepository.instance.getUserById(friendDto.targetId);
      return Friend.fromFriendDto(friendDto, authorUser!, targetUser!);
    })));

    return Rx.combineLatest2<List<Friend>, List<Friend>, List<Friend>>(
      authorStream,
      targetStream,
          (authorFriends, targetFriends) => [...authorFriends, ...targetFriends],
    );
  }

  Stream<List<UserDto>>  getListUserFriendsStream(String userId) {
    return _friendCollection
        .where('isTargetAccepted', isEqualTo: true)
        .snapshots()
        .asyncMap((snapshot) => Future.wait(snapshot.docs.map((doc) async {
      final friendDto = FriendDto.fromJson(doc.data() as Map<String, dynamic>);
      final authorUser = await UsersRepository.instance.getUserById(friendDto.authorId);
      final targetUser = await UsersRepository.instance.getUserById(friendDto.targetId);
      return friendDto.authorId == userId ? targetUser! : authorUser!;
    })));
  }

  Future<List<Friend>> getAllFriends() {
    return _friendCollection.get().then((snapshot) async => Future.wait(snapshot.docs.map((doc) async {
      final friendDto = FriendDto.fromJson(doc.data() as Map<String, dynamic>);
      final authorUser = await UsersRepository.instance.getUserById(friendDto.authorId);
      final targetUser = await UsersRepository.instance.getUserById(friendDto.targetId);
      return Friend.fromFriendDto(friendDto, authorUser!, targetUser!);
    })));
  }
}