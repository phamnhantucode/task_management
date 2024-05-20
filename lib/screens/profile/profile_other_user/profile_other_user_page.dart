import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show User;
import 'package:room_master_app/blocs/authentication/authentication_cubit.dart';
import 'package:room_master_app/common/constant.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/component/tm_elevated_button.dart';
import 'package:room_master_app/screens/profile/profile_other_user/cubit/profile_other_user_cubit.dart';

import '../../../models/dtos/user/user_dto.dart';

class ProfileOtherUserPage extends StatelessWidget {
  const ProfileOtherUserPage({super.key, required this.otherUser});

  final UserDto otherUser;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileOtherUserCubit()
        ..update(otherUser,
            context.read<AuthenticationCubit>().state.user?.uid ?? ''),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.text_profile),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 16.0),
              Container(
                width: 156,
                height: 156,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                // Add padding around the avatar
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl:
                          otherUser.imageUrl ?? AppConstants.defaultUriAvatar,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                otherUser.firstName ?? '',
                style: context.textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32.0),
              BlocBuilder<ProfileOtherUserCubit, ProfileOtherUserState>(
                builder: (context, state) {
                  var label = '';
                  var isDisable = false;
                  switch (state.friendState) {
                    case FriendState.accepted:
                      label = context.l10n.text_already_friend;
                      isDisable = true;
                      break;
                    case FriendState.waiting:
                      label = context.l10n.text_waiting;
                      isDisable = true;
                      break;
                    case FriendState.non:
                      label = context.l10n.text_add_friend;
                      break;
                    case FriendState.needAccept:
                      label = context.l10n.text_accept;
                      break;
                    case FriendState.loading:
                      label = '...';
                      isDisable = true;
                      break;
                  }
                  return TMElevatedButton(
                    label: label,
                    height: 60,
                    color: context.appColors.buttonEnable,
                    textColor: context.appColors.textOnBtnEnable,
                    isDisable: isDisable,
                    onPressed: () {
                      final userId =
                          context.read<AuthenticationCubit>().state.user?.uid ??
                              '';
                      if (state.friendState == FriendState.non) {
                        context
                            .read<ProfileOtherUserCubit>()
                            .addFriend(otherUser, userId);
                      } else if (state.friendState == FriendState.needAccept) {
                        context
                            .read<ProfileOtherUserCubit>()
                            .acceptFriend(otherUser, userId);
                      }
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
