import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:room_master_app/domain/repositories/users/users_repository.dart';
import 'package:room_master_app/domain/service/cloud_storage_service.dart';

part 'profile_bloc.freezed.dart';
part 'profile_bloc.g.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends HydratedBloc<ProfileEvent, ProfileState> {
  ProfileBloc()
      : cloudStorageService = CloudStorageService.instance,
        super(const ProfileState()) {
    on<InitBloc>(_initBloc);
    on<SetNotification>((event, emit) {
      emit(state.copyWith(isTurnOnNotification: event.isTurnOnNotification));
    });
    on<SetAvatarPath>(_handleSetAvatarPath);
  }

  final CloudStorageService cloudStorageService;

  FutureOr<void> _handleSetAvatarPath(
      SetAvatarPath event, Emitter<ProfileState> emit) async {
    final downloadPath =
        await CloudStorageService.instance.uploadImage(event.avatarPath);
    await FirebaseAuth.instance.currentUser?.updatePhotoURL(downloadPath);
    if (downloadPath != null) {
      await UsersRepository.instance.updateUserImageUrl(FirebaseAuth.instance.currentUser?.uid ?? '', downloadPath);
    }
    emit(state.copyWith(avatarPath: downloadPath));
  }

  FutureOr<void> _initBloc(InitBloc event, Emitter emit) async {
    final user = event.user;
    if (user != null) {
      emit(state.copyWith(
        avatarPath: user.photoURL,
      ));
    }
  }

  @override
  ProfileState? fromJson(Map<String, dynamic> json) {
    return ProfileState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ProfileState state) {
    return state.toJson();
  }
}
