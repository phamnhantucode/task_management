import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/friend/friend.dart';

part 'friend.freezed.dart';
part 'friend.g.dart';

@freezed
class FriendDto with _$FriendDto {
  factory FriendDto({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String authorId,
    required String targetId,
    required bool isTargetAccepted,
  }) = _FriendDto;

  factory FriendDto.fromJson(Map<String, dynamic> json) => _$FriendDtoFromJson(json);
}