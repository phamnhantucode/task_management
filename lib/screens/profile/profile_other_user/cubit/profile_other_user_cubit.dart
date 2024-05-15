import 'package:bloc/bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show User;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:room_master_app/main.dart';

import '../../../../common/utils/utils.dart';
import '../../../../domain/repositories/friends/friends_repository.dart';
import '../../../../models/dtos/friend/friend.dart';

part 'profile_other_user_cubit.freezed.dart';
part 'profile_other_user_state.dart';

class ProfileOtherUserCubit extends Cubit<ProfileOtherUserState> {
  ProfileOtherUserCubit() : super(const ProfileOtherUserState());

  void update(User otherUser, String userId) async {
    final friend =
        await FriendRepository.instance.getFriend(userId, otherUser.id);
    if (friend == null) {
      emit(state.copyWith(friendState: FriendState.non));
    } else {
      if (!friend.isTargetAccepted) {
        if (friend.author.id == userId) {
          emit(state.copyWith(friendState: FriendState.waiting));
        } else {
          emit(state.copyWith(friendState: FriendState.needAccept));
        }
      } else {
        emit(state.copyWith(friendState: FriendState.accepted));
      }
    }
  }

  void addFriend(User otherUser, String userId) async {
    await FriendRepository.instance.addFriend(FriendDto(
      createdAt: getCurrentTimestamp,
      updatedAt: getCurrentTimestamp,
      authorId: userId,
      targetId: otherUser.id,
      isTargetAccepted: false,
      id: uuid.v1(),
    ));
    update(otherUser, userId);
  }

  void acceptFriend(User otherUser, String userId) async {
    final listWaitedAccept =
        await FriendRepository.instance.getListWaitedAccepted(userId);
    FriendRepository.instance.acceptFriend(listWaitedAccept
        .firstWhere((element) => element.author.id == otherUser.id)
        .id);
    update(otherUser, userId);
  }
}
