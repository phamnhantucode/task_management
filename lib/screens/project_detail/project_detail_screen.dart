import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/common/extensions/date_time.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/component/SpacerComponent.dart';
import 'package:room_master_app/screens/component/task_container.dart';
import 'package:room_master_app/screens/component/tm_icon_button.dart';
import 'package:room_master_app/screens/component/top_header/primary.dart';
import 'package:room_master_app/screens/project_detail/project_detail_cubit.dart';

import '../new_task/new_task_screen.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({super.key, required this.projectId});

  final String projectId;

  @override
  State<StatefulWidget> createState() => ProjectDetailScreenState();
}

class ProjectDetailScreenState extends State<ProjectDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectDetailCubit()..init(widget.projectId),
      child: Builder(builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
              child: Column(
            children: [
              TopHeader(
                  title: context.l10n.text_project_detail,
                  leftAction: () {
                    context.pop();
                  }),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.orange.shade50,
                          ),
                          child: buildProjectCard(context),
                        ),
                        SpacerComponent.l(
                          isVertical: true,
                        ),
                        Text(
                          context.l10n.overview,
                          style: context.textTheme.titleLarge,
                        ),
                        SafeArea(
                            child: Text(
                          context
                                  .watch<ProjectDetailCubit>()
                                  .state
                                  .project
                                  ?.description ??
                              '',
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodyMedium
                              ?.copyWith(color: context.appColors.textGray),
                        )),
                        const SizedBox(height: 20),
                        Text(
                          context.l10n.members,
                          style: context.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 10),
                        buildMembers(),
                        const SizedBox(height: 20),
                        Text(
                          context.l10n.text_tasks,
                          style: context.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 10),
                        buildTasks(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
          floatingActionButton: MyFloatingActionButton(
            projectId: widget.projectId,
          ),
        );
      }),
    );
  }

  Widget buildTasks() {
    return BlocBuilder<ProjectDetailCubit, ProjectDetailState>(
      builder: (context, state) {
        if (state.tasks.isEmpty) {
          return Center(
              child: Text(
            'There is nothing here',
            style: context.textTheme.bodyMedium
                ?.copyWith(color: context.appColors.textGray),
          ));
        } else {
          return SizedBox(
            height: 440,
            child: ListView.builder(
              itemBuilder: (context, index) => TaskContainer(
                context: context,
                isShadowContainer: false,
                title: state.tasks[index].name,
                content: state.tasks[index].description,
                backgroundColor: Colors.blue.shade50,
                iconBackgroundColor: Colors.blue.shade100,
                contentColor: Colors.blue.shade500,
              ),
              itemCount: state.tasks.length,
            ),
          );
        }
      },
    );
  }

  Column buildProjectCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.watch<ProjectDetailCubit>().state.project?.name ?? '',
          style: context.textTheme.titleLarge,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            TMIconButton(
                icon: Icon(
                  Icons.calendar_month,
                  color: context.appColors.buttonEnable,
                ),
                onPressed: () {},
                backgroundColor: context.appColors.defaultBgContainer),
            const SizedBox(
              width: 8,
            ),
            Text(
              context
                      .watch<ProjectDetailCubit>()
                      .state
                      .project
                      ?.startDate
                      .dateTimeFormat ??
                  '',
              style: context.textTheme.labelMedium,
            )
          ],
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            Row(
              children: [
                Text(
                  context.l10n.progress,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                    child: Text(
                  context.l10n.text_percent_with_number(context
                          .watch<ProjectDetailCubit>()
                          .state
                          .progress
                          .toInt() *
                      100),
                  textAlign: TextAlign.end,
                  style: context.textTheme.labelSmall,
                ))
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: context.watch<ProjectDetailCubit>().state.progress,
                    minHeight: 10,
                    backgroundColor: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                )
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  buildMembers() {
    final settings = RestrictedAmountPositions(
      maxAmountItems: 5,
      maxCoverage: 0.3,
      minCoverage: 0.2,
    );
    return BlocBuilder<ProjectDetailCubit, ProjectDetailState>(
      builder: (context, state) {
        if (state.project == null) {
          return const SizedBox.shrink();
        } else {
          return Stack(children: [
            AvatarStack(
              settings: settings,
              height: 50,
              avatars: [
                for (var n = 0; n < state.project!.members.length; n++)
                  CachedNetworkImageProvider(
                      state.project!.members[n].imageUrl ?? getAvatarUrl(n)),
              ],
            ),
            Positioned(
                right: 0,
                child: TMIconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                  backgroundColor: context.appColors.buttonEnable.withAlpha(20),
                )),
          ]);
        }
      },
    );
  }
}

String getAvatarUrl(int n) {
  final url = 'https://robohash.org/$n?bgset=bg1';
  return url;
}

class MyFloatingActionButton extends StatefulWidget {
  const MyFloatingActionButton({super.key, required this.projectId});

  final String projectId;

  @override
  MyFloatingActionButtonState createState() => MyFloatingActionButtonState();
}

class MyFloatingActionButtonState extends State<MyFloatingActionButton> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isExpanded)
          FloatingActionButton(
            backgroundColor: context.appColors.buttonEnable,
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                side: BorderSide(
                    width: 3, color: context.appColors.buttonEnable)),
            mini: true,
            onPressed: () {
              // Add your action for this button
              // Add bottom sheet
            },
            child: const Icon(Icons.edit),
          ),
        if (_isExpanded)
          FloatingActionButton(
            backgroundColor: context.appColors.buttonEnable,
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                side: BorderSide(
                    width: 3, color: context.appColors.buttonEnable)),
            mini: true,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return NewTaskScreen(projectId: widget.projectId,);
                },
              );
            },
            child: const Icon(Icons.add),
          ),
        if (_isExpanded)
          const SizedBox(
            height: 16,
          ),
        FloatingActionButton(
          backgroundColor: context.appColors.buttonEnable,
          shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              side:
                  BorderSide(width: 3, color: context.appColors.buttonEnable)),
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Icon(_isExpanded ? Icons.close : Icons.add),
        ),
      ],
    );
  }
}
