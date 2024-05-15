part of 'user_friends_cubit.dart';

@freezed
class UserFriendsState with _$UserFriendsState {
  const factory UserFriendsState({
    @Default([]) List<Friend> friends,
    @Default([]) List<User> users,
    @Default([]) List<User> usersFiltered,
    @Default([]) List<User> usersSearched,
    @Default([]) List<Friend> userWaitingAccepts,
    @Default(false) bool isLoading,
    @Default(false) bool isSearching,
    @Default('') String searchQuery,
  }) = _UserFriendsState;
}
