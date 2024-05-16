import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/common/extensions/date_time.dart';
import 'package:room_master_app/common/utils/utils.dart';

import '../../models/domain/project/project.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.defaultBgContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  task.name,
                  style: context.textTheme.labelMedium,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: task.status.color,
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                child: Text(
                  task.status.getLocalizationText(context),
                  style: context.textTheme.bodySmall
                      ?.copyWith(color: getContrastColor(task.status.color), fontSize: 12),
                ),
              )
            ],
          ),
          Text(
            task.projectId.name,
            style: context.textTheme.bodySmall
                ?.copyWith(color: context.appColors.buttonEnable),
          ),
          buildStartDateEndDate(context),
          Divider(
            color: context.appColors.borderColor,
          ),
          Row(
            children: [
              Expanded(
                  child: buildMembers([task.assignee, task.author], context)),
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
                style:
                    context.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildMembers(List<types.User?> members, BuildContext context) {
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
