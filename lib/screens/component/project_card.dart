import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/common/extensions/date_time.dart';
import 'package:room_master_app/l10n/l10n.dart';

import '../../common/assets/app_assets.dart';
import '../../common/utils/utils.dart';
import '../../domain/repositories/project/project_repository.dart';
import '../../domain/service/qr_action.dart';
import '../../models/domain/project/project.dart';
import '../../models/dtos/project/project.dart';
import '../../models/dtos/user/user_dto.dart';
import '../../navigation/navigation.dart';
import '../project_detail/project_detail_screen.dart';
import 'dialog/qr_dialog.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final bgColor = project.color;
    final color = getContrastColor(bgColor);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: GestureDetector(
        onTap: () {
          context.push(NavigationPath.detailProject, extra: project.id);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
              color: bgColor,
              image: const DecorationImage(
                  image: AssetImage(AppAssets.imageBgContainer),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: context.appColors.borderColor,
                    offset: const Offset(0, 1),
                    spreadRadius: 0.5,
                    blurRadius: 2)
              ]),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        project.name,
                        style: context.textTheme.labelMedium
                            ?.copyWith(color: color),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showQrDialog(
                            context,
                            context.l10n.text_project_qr_invite_code,
                            context.l10n.text_content_qr_project_dialog,
                            QrAction.joinProject.encode(project.id));
                      },
                      child: const Icon(
                        Icons.share,
                        size: 18,
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_filled,
                          size: 16,
                          color: color,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          project.endDate?.dateWeeksMonthFormat ??
                              context.l10n.text_empty,
                          style: context.textTheme.bodySmall
                              ?.copyWith(color: color),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: color,
                        ),
                        const SizedBox(width: 6),
                        StreamBuilder<List<Task>>(
                            stream: ProjectRepository.instance
                                .getTasksFromProjectStream(project.id),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return Text(
                                  '${snapshot.data!.length.toString().padLeft(2, '0')} tasks',
                                  style: context.textTheme.bodyLarge
                                      ?.copyWith(color: color),
                                );
                              } else {
                                return const Text('00/00');
                              }
                            }),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          StreamBuilder<List<Task>>(
                              stream: ProjectRepository.instance
                                  .getTasksFromProjectStream(project.id),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                    '${snapshot.data!.where((element) => element.status == TaskStatus.completed).length.toString().padLeft(2, '0')}/${snapshot.data!.length.toString().padLeft(2, '0')}',
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(color: color),
                                  );
                                } else {
                                  return const Text('00/00');
                                }
                              }),
                          Expanded(child: buildMembers(project.members)),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: FutureBuilder<double>(
                            future: ProjectRepository.instance
                                .getProjectProgressFuture(project.id),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              return LinearProgressIndicator(
                                value: snapshot.data ?? 0,
                                minHeight: 5,
                                color: color,
                                backgroundColor: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Text(
                          context.l10n.progress,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                            child: FutureBuilder<double>(
                          future: ProjectRepository.instance
                              .getProjectProgressFuture(project.id),
                          builder: (BuildContext context,
                              AsyncSnapshot<double> snapshot) {
                            return Text(
                              context.l10n.text_percent_with_number(
                                  snapshot.data != null
                                      ? (snapshot.data! * 100)
                                          .toStringAsFixed(0)
                                      : ''),
                              textAlign: TextAlign.end,
                              style: context.textTheme.labelSmall,
                            );
                          },
                        ))
                      ],
                    ),
                  ],
                ),
              ]),
        ),
      ),
    );
  }

  Widget buildMembers(List<UserDto> members) {
    final settings = RestrictedAmountPositions(
        maxAmountItems: 5,
        maxCoverage: 0.3,
        minCoverage: 0.2,
        align: StackAlign.right);
    return AvatarStack(
        settings: settings,
        height: 20,
        borderWidth: 0,
        avatars: [
          for (var n = 0; n < members.length; n++)
            CachedNetworkImageProvider(members[n].imageUrl ?? getAvatarUrl(n)),
        ]);
  }
}
