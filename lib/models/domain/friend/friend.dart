import 'package:freezed_annotation/freezed_annotation.dart';

import '../../dtos/friend/friend.dart';
import '../../dtos/user/user_dto.dart';

part 'friend.freezed.dart';
part 'friend.g.dart';

@freezed
class Friend with _$Friend {
  factory Friend({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required UserDto author,
    required UserDto target,
    required bool isTargetAccepted,
  }) = _Friend;

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);

  factory Friend.fromFriendDto(FriendDto friendDto, UserDto authorUserDto, UserDto targetUserDto) {
    return Friend(
      id: friendDto.id,
      createdAt: friendDto.createdAt,
      updatedAt: friendDto.updatedAt,
      author: authorUserDto,
      target: targetUserDto,
      isTargetAccepted: friendDto.isTargetAccepted,
    );
  }
}