import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_chat_types/flutter_chat_types.dart' show User;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:room_master_app/domain/repositories/friends/friends_repository.dart';
import 'package:room_master_app/models/domain/friend/friend.dart';

part 'user_friends_cubit.freezed.dart';
part 'user_friends_state.dart';

class UserFriendsCubit extends Cubit<UserFriendsState> {
  UserFriendsCubit() : super(const UserFriendsState());

  late StreamSubscription friendsSubscription;
  late StreamSubscription usersSubscription;
  late StreamSubscription userWaitingAcceptsSubscription;

  void init() {
    usersSubscription = FriendRepository.instance
        .getAcceptedFriendsStream(
            firebase_auth.FirebaseAuth.instance.currentUser?.uid ?? '')
        .listen((friends) {
      final users = friends.map((e) {
        if (e.author.id ==
            firebase_auth.FirebaseAuth.instance.currentUser?.uid) {
          return e.target;
        } else {
          return e.author;
        }
      }).toList();

      emit(state.copyWith(
          users: users,
          usersFiltered: users
              .where((element) => state.searchQuery.isNotEmpty
                  ? element.firstName!.toLowerCase().contains(state.searchQuery)
                  : true)
              .toList()));
    });
    userWaitingAcceptsSubscription = FriendRepository.instance
        .getListWaitedAcceptedStream(
            firebase_auth.FirebaseAuth.instance.currentUser?.uid ?? '')
        .listen((friends) {
      emit(state.copyWith(userWaitingAccepts: friends));
    });
  }

  @override
  Future<void> close() {
    usersSubscription.cancel();
    userWaitingAcceptsSubscription.cancel();
    return super.close();
  }

  Future<int> getNumberOfMutualFriends(
      String userId, String otherUserId) async {
    final allFriends = await FriendRepository.instance.getAllFriends();
    final userFriends = allFriends
        .where((element) =>
            element.author.id == userId || element.target.id == userId)
        .map((e) => e.author.id == userId ? e.target.id : e.author.id)
        .toList();
    final otherUserFriends = allFriends
        .where((element) =>
            element.author.id == otherUserId ||
            element.target.id == otherUserId)
        .map((e) => e.author.id == otherUserId ? e.target.id : e.author.id)
        .toList();
    return userFriends.toSet().intersection(otherUserFriends.toSet()).length;
  }

  void acceptFriend(Friend userWaitingAccept) {
    FriendRepository.instance.acceptFriend(userWaitingAccept.id);
  }

  void declineFriend(Friend userWaitingAccept) {
    FriendRepository.instance.deleteFriend(userWaitingAccept.id);
  }

  void searchFriends(String value) {
    emit(state.copyWith(
        searchQuery: value.toLowerCase(),
        usersFiltered: state.users
            .where((element) => element.firstName!.toLowerCase().contains(value.toLowerCase()))
            .toList()));
  }
}
