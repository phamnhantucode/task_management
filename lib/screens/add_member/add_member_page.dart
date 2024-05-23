import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/component/tm_elevated_button.dart';

import '../../common/utils/utils.dart';
import '../../models/dtos/user/user_dto.dart';
import '../chat/bloc/user_friends_cubit.dart';

class AddMemberPage extends StatelessWidget {
  const AddMemberPage({super.key, required this.usersAlreadySelected});

  final List<UserDto> usersAlreadySelected;

  Widget _buildAvatar(UserDto user) {
    final color = getUserAvatarNameColor(user);
    final hasImage = user.imageUrl != null;
    final name = user.firstName ?? '';

    return Container(
      width: 54,
      height: 54,
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(user.imageUrl!) : null,
        radius: 20,
        child: !hasImage
            ? Text(
                name.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }

  void _handlePressed(UserDto otherUser, BuildContext context) async {
    context.read<UserFriendsCubit>().selectUser(otherUser);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserFriendsCubit()..init(userAlreadySelected: usersAlreadySelected),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              elevation: 1,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.text_add_member,
                    style: context.textTheme.titleMedium,
                  ),
                  Builder(
                    builder: (context) {
                      return Text(
                        context.l10n.text_number_selected(context.watch<UserFriendsCubit>().state.usersSelected.length - usersAlreadySelected.length),
                        style: context.textTheme.bodySmall,
                      );
                    }
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                _buildSearchField(context),
                Expanded(child: _buildUserList(context)),
                _buildButtons(context)
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) => Padding(
        padding:
            const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
        child: TextFormField(
          style: context.textTheme.bodySmall,
          onChanged: (value) {
            context.read<UserFriendsCubit>().searchFriends(value);
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search...",
            hintStyle: TextStyle(color: context.appColors.colorDarkGray),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey.shade600,
              size: 20,
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.all(8),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey.shade100)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey.shade100)),
          ),
        ),
      );

  Widget _buildUserList(BuildContext context) {
    return BlocBuilder<UserFriendsCubit, UserFriendsState>(
      builder: (context, state) {
        if (state.usersFiltered.isEmpty) {
          return Center(
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 200),
              child: Text(context.l10n.text_no_users),
            ),
          );
        }

        return ListView.builder(
          itemCount: state.usersFiltered.length,
          itemBuilder: (context, index) {
            final user = state.usersFiltered[index];
            final alreadyJoin = state.usersSelected.contains(user) && usersAlreadySelected.contains(user);
            return GestureDetector(
              onTap: () {
                !alreadyJoin ? _handlePressed(user, context) : null;
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: Row(
                  children: [
                    SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: state.usersSelected.contains(user),
                          shape: const CircleBorder(),
                          onChanged: (value) {
                            !alreadyJoin ? _handlePressed(user, context) : null;
                          },
                          checkColor: context.appColors.textOnBtnEnable,
                          activeColor: alreadyJoin ? context.appColors.buttonEnable.withOpacity(0.8) : context.appColors.buttonEnable,
                        )),
                    const SizedBox(width: 16),
                    _buildAvatar(user),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.firstName ?? '',
                            style: context.textTheme.labelSmall
                                ?.copyWith(color: context.appColors.textBlack)),
                        const SizedBox(height: 2),
                        Text(alreadyJoin ? context.l10n.text_already_join_project : "Management",
                            style: context.textTheme.bodySmall?.copyWith(
                                color: context.appColors.colorDarkGray)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildButtons(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        //border top + box shadow
        decoration: BoxDecoration(
          color: context.appColors.defaultBgContainer,
          boxShadow: [
            BoxShadow(
              color: context.appColors.borderColor,
              offset: const Offset(0, -1),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TMElevatedButton(
                onPressed: () {
                  context.pop();
                },
                  height: 44,
                label: context.l10n.text_cancel,
                decoration: BoxDecoration(
                  border: Border.all(color: context.appColors.borderColor
                  ),
                  borderRadius: BorderRadius.circular(8),
                )
              ),
            ),
            const SizedBox(width: 8,),
            Expanded(
              child: TMElevatedButton(
                height: 44,
                onPressed: () {

                  context
                      .pop(context.read<UserFriendsCubit>().state.usersSelected.toList()..removeWhere((element) => usersAlreadySelected.contains(element)));
                },
                label: context.l10n.text_confirm,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.appColors.textOnBtnEnable,
                ),
                color: context.appColors.buttonEnable,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
