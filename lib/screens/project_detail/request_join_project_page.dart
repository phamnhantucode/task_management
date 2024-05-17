import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:go_router/go_router.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/common/extensions/date_time.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/component/dialog/alert_dialog.dart';
import 'package:room_master_app/screens/component/tm_elevated_button.dart';
import 'package:room_master_app/screens/project_detail/project_detail_screen.dart';

import '../../models/domain/project/project.dart';

class RequestJoinProjectPage extends StatelessWidget {
  const RequestJoinProjectPage({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.text_project_detail),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showAlertDialog(
                context: context,
                title: context.l10n.text_project_detail,
                content: context.l10n.text_project_detail,
                actionsAlignment: MainAxisAlignment.center,
                rightAction: () {
                  context.pop();
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: context.appColors.defaultBgContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      project.name,
                      style: context.textTheme.labelLarge,
                    ),
                    Text(
                      project.description,
                      style: context.textTheme.bodySmall
                          ?.copyWith(color: context.appColors.textGray),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${context.l10n.text_owner}: ',
                          style: context.textTheme.bodyMedium
                              ?.copyWith(color: context.appColors.textGray),
                        ),
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(project.owner.imageUrl ?? ''),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          project.owner.firstName ?? '',
                          style: context.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          size: 18,
                          color: Colors.grey,
                        ),
                        Text(
                          project.startDate.dateWeeksMonthYearFormat,
                          style: context.textTheme.bodySmall
                              ?.copyWith(color: Colors.grey),
                        ),
                        const Text(' - '),
                        Text(
                          project.endDate?.dateWeeksMonthYearFormat ?? '??',
                          style: context.textTheme.bodySmall
                              ?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${context.l10n.members}: ',
                            style: context.textTheme.bodySmall
                                ?.copyWith(color: Colors.grey)),
                        SizedBox(
                            width: 60,
                            child: buildMembers(project.members, context))
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TMElevatedButton(
                label: context.l10n.text_request_to_join_project,
                height: 46,
                color: context.appColors.buttonEnable,
                textColor: context.appColors.textOnBtnEnable,
                onPressed: () {
                  showAlertDialog(
                    context: context,
                    title: context.l10n.text_request_already_sent,
                    content: context.l10n
                        .text_your_request_have_been_sent_waiting_for_leader_accept_you_join_project,
                    rightAction: () {
                      context
                        ..pop()
                        ..pop();
                    },
                  );
                },
              ),
            ],
          ),
        ),
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
}
