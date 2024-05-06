import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path/path.dart';
import 'package:room_master_app/common/app_setting.dart';
import 'package:room_master_app/common/constant.dart';
import 'package:room_master_app/domain/service/cloud_storage_service.dart';
import 'package:room_master_app/main.dart';

part 'profile_bloc.freezed.dart';
part 'profile_bloc.g.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends HydratedBloc<ProfileEvent, ProfileState> {
  ProfileBloc()
      : cloudStorageService = CloudStorageService(),
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
    final file = File(event.avatarPath);
    final downloadPath = await cloudStorageService.uploadFile(AppConstants.imageCloudStoragePath, '${uuid.v1()}${extension(event.avatarPath)}' , await file.readAsBytes());
    await FirebaseAuth.instance.currentUser?.updatePhotoURL(downloadPath);
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
