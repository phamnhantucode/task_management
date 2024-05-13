part of 'profile_other_user_cubit.dart';

enum FriendState { accepted, waiting, non, needAccept, loading}

@freezed
class ProfileOtherUserState with _$ProfileOtherUserState {
  const factory ProfileOtherUserState(
          {@Default(FriendState.loading) FriendState friendState}) =
      _ProfileOtherUserState;
}
