import 'package:another_flushbar/flushbar.dart';
import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/blocs/authentication/authentication_cubit.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/common/extensions/date_time.dart';
import 'package:room_master_app/common/utils/utils.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/models/dtos/project/project.dart';
import 'package:room_master_app/screens/component/SpacerComponent.dart';
import 'package:room_master_app/screens/component/calendar_date_picker_dialog.dart';
import 'package:room_master_app/screens/component/task_container.dart';
import 'package:room_master_app/screens/component/tm_icon_button.dart';
import 'package:room_master_app/screens/component/top_header/primary.dart';
import 'package:room_master_app/screens/project_detail/project_detail_cubit.dart';

import '../component/tm_elevated_button.dart';
import '../component/tm_text_field.dart';
import '../new_task/new_task_screen.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({super.key, required this.projectId});

  final String projectId;

  @override
  State<StatefulWidget> createState() => ProjectDetailScreenState();
}

class ProjectDetailScreenState extends State<ProjectDetailScreen> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectDetailCubit()..init(widget.projectId),
      child: Builder(builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                context.l10n.overview,
                                style: context.textTheme.titleLarge,
                              ),
                              _isEditing
                                  ? buildEditIcon(
                                      context,
                                      onTap: () =>
                                          showModalEditProjectDescription(
                                              context),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          SafeArea(
                              child: Text(
                            context
                                .watch<ProjectDetailCubit>()
                                .state
                                .projectDescription,
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
            ),
          )),
          floatingActionButton: MyFloatingActionButton(
            projectId: widget.projectId,
            isEditing: _isEditing,
            onEditing: (bool isEditing) {
              setState(() {
                _isEditing = isEditing;
              });
            },
          ),
        );
      }),
    );
  }

  Widget buildTasks() {
    return BlocBuilder<ProjectDetailCubit, ProjectDetailState>(
      builder: (context, state) {
        if (state.tasksCopy.isEmpty) {
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
                title: state.tasksCopy[index].name,
                content: state.tasksCopy[index].description,
                backgroundColor: Colors.blue.shade50,
                iconBackgroundColor: Colors.blue.shade100,
                contentColor: Colors.blue.shade500,
                suffix: _isEditing ? TMIconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    context.read<ProjectDetailCubit>().deleteTask(state.tasksCopy[index].id);
                  },
                  backgroundColor: context.appColors.buttonEnable.withAlpha(20),
                ): null,
              ) ,
              itemCount: state.tasksCopy.length,
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
        Row(
          children: [
            Text(
              context.watch<ProjectDetailCubit>().state.projectName,
              style: context.textTheme.titleLarge,
            ),
            _isEditing
                ? buildEditIcon(
                    context,
                    onTap: () => showModalEditProjectName(context),
                  )
                : const SizedBox.shrink(),
          ],
        ),
        const SizedBox(height: 20),
        buildStartEndDateSection(context),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<ProjectDetailCubit, ProjectDetailState>(
              builder: (context, state) {
                if (state.startDate != null && state.endDate != null) {
                  final diff =
                      state.endDate!.difference(getCurrentTimestamp).inHours;
                  final backgroundColor = getBackgroundColor(diff,
                      state.endDate!.difference(state.startDate!).inHours);
                  var contrastColor = getContrastColor(backgroundColor);
                  return Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time_filled,
                          size: 16,
                          color: contrastColor,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          context.l10n.text_hours_left(diff),
                          style: context.textTheme.bodySmall
                              ?.copyWith(color: contrastColor),
                        )
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 20,
                  color: Colors.lightBlueAccent,
                ),
                const SizedBox(
                  width: 8,
                ),
                BlocBuilder<ProjectDetailCubit, ProjectDetailState>(
                  builder: (context, state) {
                    return Text(
                      '${state.tasksCopy.where((element) => element.status == TaskStatus.completed).length}/${state.tasksCopy.length} tasks',
                      style: context.textTheme.bodyMedium
                          ?.copyWith(color: context.appColors.textGray),
                    );
                  },
                )
              ],
            )
          ],
        ),
        SpacerComponent.s(
          isVertical: true,
        ),
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

  Widget buildStartEndDateSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildDateRow(
            context,
            Icons.calendar_month,
            context.l10n.text_start_date,
            context
                    .watch<ProjectDetailCubit>()
                    .state
                    .startDate
                    ?.dateTimeFormat ??
                '',
            (dateTime) =>
                context.read<ProjectDetailCubit>().updateStartDate(dateTime),
            initialDate: context.watch<ProjectDetailCubit>().state.startDate,
            lastDate: context.watch<ProjectDetailCubit>().state.endDate),
        const SizedBox(height: 10),
        _buildDateRow(
            context,
            Icons.access_alarms_sharp,
            context.l10n.text_end_date,
            context.watch<ProjectDetailCubit>().state.endDate?.dateTimeFormat ??
                context.l10n.text_empty,
            (dateTime) =>
                context.read<ProjectDetailCubit>().updateEndDate(dateTime),
            initialDate: context.watch<ProjectDetailCubit>().state.endDate,
            firstDate: context.watch<ProjectDetailCubit>().state.startDate),
      ],
    );
  }

  Widget _buildDateRow(BuildContext context, IconData icon, String labelText,
      String valueText, ValueChanged<DateTime> onDateSelected,
      {DateTime? initialDate, DateTime? firstDate, DateTime? lastDate}) {
    return Row(
      children: [
        TMIconButton(
            icon: Icon(icon,
                color: _isEditing
                    ? Colors.red.shade300
                    : context.appColors.buttonEnable),
            onPressed: () async {
              if (_isEditing) {
                final dateTime = await TMCalendarDateTimePicker(
                        firstDate: firstDate,
                        initialDate: initialDate,
                        lastDate: lastDate)
                    .onShowDialog(context);
                if (dateTime != null) {
                  onDateSelected(dateTime);
                }
              }
            },
            backgroundColor: context.appColors.defaultBgContainer),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(labelText,
                style: context.textTheme.bodyMedium
                    ?.copyWith(color: context.appColors.textGray)),
            Text(valueText, style: context.textTheme.bodyLarge),
          ],
        )
      ],
    );
  }

  Padding buildEditIcon(BuildContext context, {Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Icon(
          Icons.edit_outlined,
          size: 20,
          color: Colors.red.shade300,
        ),
      ),
    );
  }

  void showModalEditProjectName(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (innerContext) {
        return BlocProvider.value(
          value: context.read<ProjectDetailCubit>(),
          child: SafeArea(
            child: SingleChildScrollView(
              padding:
                  EdgeInsets.only(bottom: context.mediaQuery.viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.text_project_name,
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    TMTextField(
                      hintText: context.l10n.text_project_name,
                      autoFocus: true,
                      borderColor: context.appColors.borderColor,
                      initialText: context
                          .watch<ProjectDetailCubit>()
                          .state
                          .project
                          ?.name,
                      onTextChange: (value) {
                        context
                            .read<ProjectDetailCubit>()
                            .updateProjectName(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    TMElevatedButton(
                      label: context.l10n.text_save,
                      borderRadius: 8,
                      color: context.appColors.buttonEnable,
                      style: context.textTheme.bodyMedium
                          ?.copyWith(color: context.appColors.textWhite),
                      height: 54,
                      onPressed: () {
                        // context.read<ProjectDetailCubit>().updateProject();
                        context.pop();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showModalEditProjectDescription(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (innerContext) {
        return BlocProvider.value(
          value: context.read<ProjectDetailCubit>(),
          child: SafeArea(
            child: SingleChildScrollView(
              padding:
                  EdgeInsets.only(bottom: context.mediaQuery.viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.text_project_description,
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    TMTextField(
                      hintText: context.l10n.text_project_description,
                      autoFocus: true,
                      borderColor: context.appColors.borderColor,
                      initialText: context
                          .watch<ProjectDetailCubit>()
                          .state
                          .project
                          ?.description,
                      maxLines: 4,
                      onTextChange: (value) {
                        context
                            .read<ProjectDetailCubit>()
                            .updateProjectDescription(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    TMElevatedButton(
                      label: context.l10n.text_save,
                      borderRadius: 8,
                      color: context.appColors.buttonEnable,
                      style: context.textTheme.bodyMedium
                          ?.copyWith(color: context.appColors.textWhite),
                      height: 54,
                      onPressed: () {
                        // context.read<ProjectDetailCubit>().updateProject();
                        context.pop();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
  const MyFloatingActionButton({
    required this.projectId,
    required this.isEditing,
    required this.onEditing,
    Key? key,
  }) : super(key: key);

  final String projectId;
  final bool isEditing;
  final ValueChanged<bool> onEditing;

  @override
  _MyFloatingActionButtonState createState() => _MyFloatingActionButtonState();
}

class _MyFloatingActionButtonState extends State<MyFloatingActionButton> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isExpanded) _buildMiniFab(Icons.edit, _toggleEditingMode),
        if (_isExpanded) _buildMiniFab(Icons.add, _showNewTaskScreen),
        if (widget.isEditing) _buildMainFab(Icons.close, _toggleCancel),
        const SizedBox(height: 8),
        _buildMainFab(
            _isExpanded
                ? Icons.close
                : (widget.isEditing ? Icons.check : Icons.add),
            _toggleExpansion),
      ],
    );
  }

  FloatingActionButton _buildMiniFab(IconData icon, VoidCallback onPressed) {
    return FloatingActionButton(
      backgroundColor: context.appColors.buttonEnable,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
        side: BorderSide(width: 3, color: context.appColors.buttonEnable),
      ),
      mini: true,
      onPressed: onPressed,
      child: Icon(icon),
    );
  }

  FloatingActionButton _buildMainFab(IconData icon, VoidCallback onPressed) {
    return FloatingActionButton(
      backgroundColor: context.appColors.buttonEnable,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
        side: BorderSide(width: 3, color: context.appColors.buttonEnable),
      ),
      onPressed: onPressed,
      child: Icon(icon),
    );
  }

  void _toggleEditingMode() {
    final project = context.read<ProjectDetailCubit>().state.project;
    final user = context.read<AuthenticationCubit>().state.user;
    if (user?.uid == project?.owner.id) {
      widget.onEditing(!widget.isEditing);
      setState(() => _isExpanded = false);
    } else {
      Flushbar(
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(16),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: Colors.orangeAccent,
        message: context.l10n.text_your_are_not_the_owner_of_this_project,
        duration:  const Duration(seconds: 2),
      ).show(context);
    }
  }

  void _showNewTaskScreen() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => NewTaskScreen(projectId: widget.projectId),
    );
  }

  void _toggleExpansion() {
    if (widget.isEditing) {
      widget.onEditing(false);
      context.read<ProjectDetailCubit>().updateProject();
    } else {
      setState(() => _isExpanded = !_isExpanded);
    }
  }

  void _toggleCancel() {
    context.read<ProjectDetailCubit>().cancelUpdateProject();
    widget.onEditing(false);
  }
}
