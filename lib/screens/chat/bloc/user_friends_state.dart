part of 'user_friends_cubit.dart';

@freezed
class UserFriendsState with _$UserFriendsState {
  const factory UserFriendsState({
    @Default([]) List<Friend> friends,
    @Default([]) List<UserDto> users,
    @Default([]) List<UserDto> usersFiltered,
    @Default([]) List<UserDto> usersSearched,
    @Default([]) List<UserDto> usersSelected,
    @Default([]) List<Friend> userWaitingAccepts,
    @Default(false) bool isLoading,
    @Default(false) bool isSearching,
    @Default('') String searchQuery,
  }) = _UserFriendsState;
}
