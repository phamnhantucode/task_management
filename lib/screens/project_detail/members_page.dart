import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/component/dialog/alert_dialog.dart';
import 'package:room_master_app/screens/component/empty_page.dart';
import 'package:room_master_app/screens/project_detail/member_cubit/member_cubit.dart';

import '../../common/assets/app_assets.dart';
import '../../common/utils/utils.dart';
import '../../models/dtos/user/user_dto.dart';
import '../component/tm_elevated_button.dart';

class MembersPage extends StatelessWidget {
  const MembersPage({
    super.key,
    required this.projectId, this.selectedUsers,
  });

  final String projectId;
  final List<UserDto>? selectedUsers;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MemberCubit()..init(projectId, selectedUsers),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Members'),
            ),
            body: Column(
              children: [
                _buildSearchField(context),
                Expanded(child: _buildUserList(context)),
                if (selectedUsers != null)
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
          onChanged: (value) {},
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
    return BlocBuilder<MemberCubit, MemberState>(
      builder: (context, state) {
        if (state.memberFiltered.isEmpty) {
          return Center(
            child: EmptyPage(
              object: 'Members',
            ),
          );
        }

        return ListView.builder(
          itemCount: state.memberFiltered.length,
          itemBuilder: (context, index) {
            final user = state.memberFiltered[index];
            return GestureDetector(
              onTap: () {
                if (selectedUsers?.contains(user) ?? false) {
                } else {
                  context
                      .read<MemberCubit>()
                      .assignTaskFor(user);
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: Row(
                  children: [
                    if (selectedUsers != null)
                      Checkbox(
                        activeColor: context.appColors.buttonEnable,
                        checkColor: context.appColors.textOnBtnEnable,
                        shape: CircleBorder(),
                        value: state.memberSelected
                            .any((element) => element.id == user.id),
                        onChanged: (value) {
                          if (selectedUsers?.contains(user) ?? false) {
                          } else {
                            context
                                .read<MemberCubit>()
                                .assignTaskFor(user);
                          }
                        },
                      ),
                    _buildAvatar(user),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.firstName ?? '',
                              style: context.textTheme.labelSmall?.copyWith(
                                  color: context.appColors.textBlack)),
                          const SizedBox(height: 2),
                          selectedUsers != null ?
                            Text(selectedUsers!.contains(user) ? 'Assigned' : 'Not assigned',
                                style: context.textTheme.bodySmall?.copyWith(
                                    color: context.appColors.colorDarkGray)) :
                            Text('Member',
                                style: context.textTheme.bodySmall?.copyWith(
                                    color: context.appColors.colorDarkGray)),

                        ],
                      ),
                    ),
                    if (selectedUsers == null) IconButton(
                        style: IconButton.styleFrom(
                            side: const BorderSide(color: Colors.red)),
                        onPressed: () {
                          showAlertDialog(
                              context: context,
                              title: 'Hey',
                              content: 'Are you sure to remove this person',
                              leftAction: () {
                                context.pop();
                              },
                              rightAction: () {
                                context
                                    .read<MemberCubit>()
                                    .removeMember(user.id);
                                context.pop();
                              });
                        },
                        icon: SvgPicture.asset(
                          AppAssets.iconDelete,
                          color: Colors.red,
                          width: 16,
                          height: 16,
                        ))
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAvatar(UserDto user) {
    final color = getUserAvatarNameColor(user);
    final hasImage = user.imageUrl != null;
    final name = user.firstName ?? '';

    return Container(
      width: 60,
      height: 60,
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
                      .pop(context.read<MemberCubit>().state.memberSelected.toList()..removeWhere((element) => selectedUsers!.contains(element)));
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
