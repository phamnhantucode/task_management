part of 'member_cubit.dart';

@freezed
class MemberState with _$MemberState {
  const factory MemberState({
    @Default([]) List<UserDto> members,
    @Default([]) List<UserDto> memberFiltered,
    @Default([]) List<UserDto> memberSelected,
    @Default('') String searchQuery,
  }) = _MemberState;
}
