import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDto with _$UserDto {
  factory UserDto({
    required String id,
    String? email,
    String? firstName,
    String? imageUrl,
    String? notificationToken,
    @EpochDateTimeConverter()
    DateTime? createAt,
    @EpochDateTimeConverter()
    DateTime? updateAt,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  static types.User toUser(UserDto userDto) {
    return types.User(
      id: userDto.id,
      imageUrl: userDto.imageUrl,
      metadata: userDto.toJson(),
      firstName: userDto.firstName,
    );
  }
}

class EpochDateTimeConverter implements JsonConverter<DateTime, int> {
  const EpochDateTimeConverter();

  @override
  DateTime fromJson(int json) => DateTime.fromMillisecondsSinceEpoch(json);

  @override
  int toJson(DateTime object) => object.millisecondsSinceEpoch;
}
