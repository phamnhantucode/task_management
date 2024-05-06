part of 'profile_bloc.dart';

sealed class ProfileEvent{}

class SetNotification extends ProfileEvent {
  final bool isTurnOnNotification;
  SetNotification({required this.isTurnOnNotification});
}

class SetAvatarPath extends ProfileEvent {
  final String avatarPath;
  SetAvatarPath({required this.avatarPath});
}

class InitBloc extends ProfileEvent {
  final User? user;

  InitBloc({required this.user});

}

