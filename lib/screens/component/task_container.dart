import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:room_master_app/blocs/authentication/authentication_cubit.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/common/extensions/date_time.dart';
import 'package:room_master_app/common/utils/utils.dart';
import 'package:room_master_app/domain/repositories/project/project_repository.dart';
import 'package:room_master_app/l10n/l10n.dart';

import '../../models/domain/project/project.dart';
import '../../models/dtos/user/user_dto.dart';
import '../project_detail/members_page.dart';
import '../project_detail/project_detail_screen.dart';

class TaskContainer extends StatelessWidget {
  const TaskContainer({
    super.key,
    required this.context,
    required this.title,
    required this.content,
    this.backgroundColor,
    this.onTap,
    this.taskIcon,
    this.suffix,
    this.iconBackgroundColor,
    this.contentColor,
    this.isShadowContainer = true,
    this.onLongPress,
  });

  final BuildContext context;
  final bool isShadowContainer;
  final String title;
  final String content;
  final Color? backgroundColor;
  final Color? iconBackgroundColor;
  final Color? contentColor;
  final Function? onTap;
  final Widget? taskIcon;
  final Widget? suffix;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      onLongPress: () {
        onLongPress?.call();
        HapticFeedback.vibrate();
      },
      child: Container(
        margin: const EdgeInsets.only(
          top: 16,
        ),
        padding: const EdgeInsets.all(12),
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          boxShadow: isShadowContainer
              ? [
                  BoxShadow(
                    color: context.appColors.borderColor,
                    spreadRadius: 1,
                    blurRadius: 2, // Moves shadow to the top
                  ),
                ]
              : [],
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor ?? context.appColors.defaultBgContainer,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: iconBackgroundColor,
                      borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsetsDirectional.all(10),
                  child: Center(
                    child: Image.network(
                      "https://cdn-icons-png.flaticon.com/128/11389/11389139.png",
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.labelMedium,
                    ),
                    Text(
                      content.replaceAll('\n', ' '),
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: contentColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
            suffix ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class TaskContainer2 extends StatelessWidget {
  const TaskContainer2({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: context.appColors.defaultBgContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onLongPress: () {
          //vibrate
          HapticFeedback.vibrate();
          showMaterialModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            builder: (context) {
              return buildTaskActionsBottomSheet(context);
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      task.name,
                      style: context.textTheme.labelMedium,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: task.status.color,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Text(
                      task.status.getLocalizationText(context),
                      style: context.textTheme.bodySmall?.copyWith(
                          color: getContrastColor(task.status.color),
                          fontSize: 12),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                task.projectId.name,
                style: context.textTheme.bodySmall
                    ?.copyWith(color: context.appColors.buttonEnable),
              ),
              buildStartDateEndDate(context),
              const SizedBox(
                height: 6,
              ),
              Divider(
                color: context.appColors.borderColor,
              ),
              Row(
                children: [
                  Expanded(
                      child: buildMembers(
                          [...task.assignees, task.author], context)),
                  const Icon(
                    Icons.access_time,
                    color: Colors.grey,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    '${task.startDate?.timeFormat ?? ' ?? '} - ${task.endDate?.timeFormat ?? ' ?? '}',
                    style: context.textTheme.bodySmall
                        ?.copyWith(color: Colors.grey),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  SafeArea buildTaskActionsBottomSheet(BuildContext context) {
    final isOwner =
        task.author.id == context.read<AuthenticationCubit>().state.user?.uid;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.edit),
              ),
              title: Text(context.l10n.text_edit_task),
              onTap: () {},
            ),
            if (isOwner)
              ListTile(
                leading: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.delete),
                ),
                title: Text(context.l10n.text_delete_task),
                onTap: () {
                  ProjectRepository.instance
                      .deleteTaskFromProject(task.id, task.projectId.id);
                },
              ),
            ListTile(
              leading: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.supervised_user_circle_outlined),
              ),
              title: Text(context.l10n.text_assign_to_me),
              onTap: () async {
                  ProjectRepository.instance.addTaskAssignees(
                      task.id, task.projectId.id, [context.read<AuthenticationCubit>().state.user?.uid ?? '']);
              },
            ),
            if (isOwner)
              ListTile(
                leading: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.supervised_user_circle_outlined),
                ),
                title: Text(context.l10n.text_add_assignee),
                onTap: () async {
                  final newAssignees = await Navigator.of(context).push<List<UserDto>>(
                    MaterialPageRoute(
                      //add transition
                        builder: (innerContext) =>
                            MembersPage(projectId: task.projectId.id, selectedUsers: task.assignees,)),
                  );
                  if (newAssignees != null && newAssignees.isNotEmpty) {
                    ProjectRepository.instance.addTaskAssignees(
                        task.id, task.projectId.id, newAssignees.map((e) => e.id).toList());
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget buildMembers(List<UserDto?> members, BuildContext context) {
    final settings = RestrictedAmountPositions(
        maxAmountItems: 5,
        maxCoverage: 0.3,
        minCoverage: 0.2,
        align: StackAlign.left);
    return AvatarStack(
        settings: settings,
        height: 24,
        borderWidth: 1,
        borderColor: context.appColors.defaultBgContainer,
        avatars: [
          for (var n = 0; n < members.length; n++)
            CachedNetworkImageProvider(members[n]?.imageUrl ?? getAvatarUrl(n)),
        ]);
  }

  Row buildStartDateEndDate(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            const Icon(
              Icons.calendar_month,
              color: Colors.grey,
              size: 16,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              task.startDate?.dateWeeksMonthYearFormat ?? '??',
              style: context.textTheme.bodySmall,
            ),
          ],
        ),
        const Text(' - '),
        Text(
          task.endDate?.dateWeeksMonthYearFormat ?? '??',
          style: context.textTheme.bodySmall,
        ),
      ],
    );
  }
}
