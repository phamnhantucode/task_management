import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show User;

import '../../dtos/friend/friend.dart';

part 'friend.freezed.dart';
part 'friend.g.dart';

@freezed
class Friend with _$Friend {
  factory Friend({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required User author,
    required User target,
    required bool isTargetAccepted,
  }) = _Friend;

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);

  factory Friend.fromFriendDto(FriendDto friendDto, User authorUser, User targetUser) {
    return Friend(
      id: friendDto.id,
      createdAt: friendDto.createdAt,
      updatedAt: friendDto.updatedAt,
      author: authorUser,
      target: targetUser,
      isTargetAccepted: friendDto.isTargetAccepted,
    );
  }
}