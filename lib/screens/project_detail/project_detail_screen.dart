import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:room_master_app/blocs/authentication/authentication_cubit.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/common/extensions/date_time.dart';
import 'package:room_master_app/common/utils/utils.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/models/dtos/project/project.dart';
import 'package:room_master_app/screens/component/SpacerComponent.dart';
import 'package:room_master_app/screens/component/calendar_date_picker_dialog.dart';
import 'package:room_master_app/screens/component/empty_page.dart';
import 'package:room_master_app/screens/component/task_container.dart';
import 'package:room_master_app/screens/component/tm_icon_button.dart';
import 'package:room_master_app/screens/project_detail/project_detail_cubit.dart';
import 'package:room_master_app/screens/project_detail/project_menu_action_page.dart';

import '../../domain/service/cloud_storage_service.dart';
import '../../domain/service/file_picker_service.dart';
import '../../models/domain/project/project.dart';
import '../../models/dtos/user/user_dto.dart';
import '../component/bottomsheet/upload_attachment_page.dart';
import '../component/tm_elevated_button.dart';
import '../component/tm_text_field.dart';
import '../new_task/new_task_screen.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({super.key, required this.projectId});

  final String projectId;

  @override
  State<StatefulWidget> createState() => ProjectDetailScreenState();
}

class ProjectDetailScreenState extends State<ProjectDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEditing = false;
  String searchMemberText = '';
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectDetailCubit()..init(widget.projectId),
      child: Builder(builder: (context) {
        final projectColor =
            context.watch<ProjectDetailCubit>().state.project?.color;
        final contrastColor = getContrastColor(projectColor ?? Colors.white);
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: context.appColors.defaultBgContainer,
          appBar: AppBar(
            backgroundColor: projectColor,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: contrastColor,
              ),
              onPressed: () {
                context.pop();
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.chat_bubble_outline,
                  color: contrastColor,
                ),
                onPressed: () {},
              ),
              Builder(builder: (context) {
                return IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: contrastColor,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              }),
            ],
          ),
          endDrawer: const ProjectMenuActionPage(),
          body: SafeArea(
              child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16)),
                          color: context
                              .watch<ProjectDetailCubit>()
                              .state
                              .project
                              ?.color,
                        ),
                        child: buildProjectCard(context),
                      ),
                      SpacerComponent.m(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: buildDescription(context),
                      ),
                      SpacerComponent.m(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: buildAttachments(context),
                      ),
                      SpacerComponent.m(),
                      SizedBox(height: 500, child: buildTabs(context)),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              )
            ],
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
          return EmptyPage(
            height: 300,
            object: context.l10n.text_tasks,
          );
        } else {
          return Container(
            color: Colors.grey.shade100,
            child: ListView.builder(
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: TaskContainer2(task: state.tasksCopy[index]),
              ),
              itemCount: state.tasksCopy.length,
            ),
          );
        }
      },
    );
  }

  Column buildProjectCard(BuildContext context) {
    final projectColor =
        context.watch<ProjectDetailCubit>().state.project?.color;
    final contrastColor = getContrastColor(projectColor ?? Colors.white);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.watch<ProjectDetailCubit>().state.projectName,
                style: context.textTheme.titleLarge
                    ?.copyWith(color: contrastColor),
              ),
            ),
            _isEditing
                ? buildEditIcon(
                    context,
                    onTap: () => showModalEditProjectName(context),
                  )
                : const SizedBox.shrink(),
          ],
        ),
        const SizedBox(height: 16),
        // buildStartEndDateSection(context),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${context.l10n.text_end_date}:',
                  style: context.textTheme.bodySmall
                      ?.copyWith(color: contrastColor.withOpacity(0.9)),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      size: 18,
                      color: contrastColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      context
                              .watch<ProjectDetailCubit>()
                              .state
                              .endDate
                              ?.dateTimeFormat ??
                          '???',
                      style: context.textTheme.labelSmall
                          ?.copyWith(color: contrastColor),
                    ),
                  ],
                )
              ],
            ),
            Expanded(child: buildMembers()),
            const SizedBox(
              width: 4,
            ),
            GestureDetector(
              onTap: () {
                // showModalBottomSheet(
                //   context: context,
                //   isScrollControlled: true,
                //   builder: (context) => buildInvitableList(context),
                // );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: context.appColors.buttonEnable,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Text(
                  context.l10n.text_invite,
                  style: context.textTheme.bodyMedium
                      ?.copyWith(color: context.appColors.textWhite),
                ),
              ),
            ),
          ],
        ),

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
                Icon(
                  Icons.check_circle,
                  size: 20,
                  color: contrastColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                BlocBuilder<ProjectDetailCubit, ProjectDetailState>(
                  builder: (context, state) {
                    return Text(
                      '${state.tasksCopy.where((element) => element.status == TaskStatus.completed).length}/${state.tasksCopy.length} tasks',
                      style: context.textTheme.bodyMedium
                          ?.copyWith(color: contrastColor),
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
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        )
                      ],
                    ),
                    child: LinearProgressIndicator(
                      value: context.watch<ProjectDetailCubit>().state.progress,
                      minHeight: 8,
                      backgroundColor: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
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
                  style: context.textTheme.labelSmall
                      ?.copyWith(color: contrastColor.withOpacity(0.8)),
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
                  style: context.textTheme.labelSmall
                      ?.copyWith(color: contrastColor.withOpacity(0.8)),
                ))
              ],
            ),
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

  Widget buildMembers() {
    final settings = RestrictedAmountPositions(
        maxAmountItems: 5,
        maxCoverage: 0.3,
        minCoverage: 0.2,
        align: StackAlign.right);
    return BlocBuilder<ProjectDetailCubit, ProjectDetailState>(
      builder: (context, state) {
        return state.project == null
            ? const SizedBox.shrink()
            : AvatarStack(
                settings: settings,
                borderColor: Colors.white,
                borderWidth: 1,
                height: 28,
                avatars: [
                  for (var n = 0; n < state.project!.members.length; n++)
                    CachedNetworkImageProvider(
                        state.project!.members[n].imageUrl ?? getAvatarUrl(n)),
                ],
              );
      },
    );
  }

  buildSearch() {
    return SearchBar(
      controller: _searchController,
      padding: const MaterialStatePropertyAll<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 16.0)),
      onChanged: (text) {
        setState(() {
          searchMemberText = text;
        });
      },
      trailing: <Widget>[
        IconButton(onPressed: () {}, icon: const Icon(Icons.search))
      ],
    );
  }

  bool _isUploading = false;

  void _handleFileSelection(BuildContext context) async {
    final filePath = await FileService.instance.fileSelection(FileType.any);
    if (filePath != null) {
      _setAttachmentUploading(true);
      final downloadPath =
          await CloudStorageService.instance.uploadFile(filePath);
      if (downloadPath != null) {
        context.read<ProjectDetailCubit>().addAttachment(
            fileName: path.basename(filePath), downloadUrl: downloadPath);

        _setAttachmentUploading(false);
      }
    }
  }

  void _setAttachmentUploading(bool bool) {
    setState(() {
      _isUploading = bool;
    });
  }

  Widget buildAttachments(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.text_attachment,
              style: context.textTheme.titleSmall,
            ),
            isOwnerOfProject(context)
                ? buildAddAttachmentButton(context)
                : const SizedBox.shrink()
          ],
        ),
        BlocBuilder<ProjectDetailCubit, ProjectDetailState>(
          builder: (context, state) {
            if (state.attachments.isNotEmpty) {
              final imageAttachments = state.attachments
                  .where((attachment) => isImageFile(attachment.fileName))
                  .toList();
              final otherAttachments = state.attachments
                  .where((attachment) => !isImageFile(attachment.fileName))
                  .toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (var n = 0; n < imageAttachments.length; n++)
                        AttachmentDownloadable(
                          attachment: imageAttachments[n],
                          isRemovable: _isEditing,
                          isImage: true,
                          onRemove: () {
                            context
                                .read<ProjectDetailCubit>()
                                .removeAttachment(imageAttachments[n]);
                          },
                        ),
                    ],
                  ),
                  SpacerComponent.s(),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (var n = 0; n < otherAttachments.length; n++)
                        AttachmentDownloadable(
                          attachment: otherAttachments[n],
                          isRemovable: _isEditing,
                          onRemove: () {
                            context
                                .read<ProjectDetailCubit>()
                                .removeAttachment(otherAttachments[n]);
                          },
                        ),
                    ],
                  ),
                ],
              );
            } else {
              return Text(
                  context.l10n.text_you_currently_have_no_something(
                      context.l10n.text_attachment),
                  style: context.textTheme.bodyMedium
                      ?.copyWith(color: context.appColors.textGray));
            }
          },
        ),
      ],
    );
  }

  bool isOwnerOfProject(BuildContext context) {
    return context.read<AuthenticationCubit>().state.user?.uid ==
        context.read<ProjectDetailCubit>().state.project?.owner.id;
  }

  GestureDetector buildAddAttachmentButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext innerContext) => BlocProvider.value(
            value: context.read<ProjectDetailCubit>(),
            child: UploadAttachmentPage(
              onFileSelection: () {
                _handleFileSelection(context);
                context.pop();
              },
              onCancel: () {
                context.pop();
              },
            ),
          ),
        );
      },
      child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Text(
            context.l10n.text_add_attachment,
            style: context.textTheme.bodySmall
                ?.copyWith(color: context.appColors.buttonEnable),
          )),
    );
  }

  _buildAvatar(UserDto user) {
    final color = getUserAvatarNameColor(user);
    final hasImage = user.imageUrl != null;
    final name = user.firstName ?? '';

    return Container(
      width: 48,
      height: 48,
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

  Widget buildNote(BuildContext context, Notes note, Color color) {
    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0))),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding: const EdgeInsets.all(16),
        child: Text(
          note.content,
          style: context.textTheme.bodySmall
              ?.copyWith(color: getContrastColor(color.withOpacity(0.5))),
        ),
      ),
    );
  }

  Widget buildDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              context.l10n.text_description,
              style: context.textTheme.titleMedium,
            ),
            _isEditing
                ? buildEditIcon(
                    context,
                    onTap: () => showModalEditProjectDescription(context),
                  )
                : const SizedBox.shrink(),
          ],
        ),
        const SizedBox(height: 6),
        BlocBuilder<ProjectDetailCubit, ProjectDetailState>(
          builder: (context, state) {
            return Text(
              state.projectDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyMedium?.copyWith(
                  color: context.appColors.textBlack.withOpacity(0.9)),
            );
          },
        ),
      ],
    );
  }

  Widget buildTabs(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 1,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: TabBar(
            controller: _tabController,
            indicatorColor: context.appColors.buttonEnable,
            dividerColor: Colors.transparent,
            tabs: [
              Tab(
                text: context.l10n.text_tasks,
              ),
              Tab(
                text: context.l10n.text_notes,
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
              controller: _tabController,
              children: [buildTasks(), buildNotes(context)]),
        ),
      ],
    );
  }

  Widget buildNotes(BuildContext context) {
    return BlocBuilder<ProjectDetailCubit, ProjectDetailState>(
      builder: (context, state) {
        if (state.notes.isEmpty) {
          return EmptyPage(
            height: 300,
            object: context.l10n.text_tasks,
          );
        } else {
          return Container(
            color: Colors.grey.shade100,
            child: ListView.builder(
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildNote(context, state.notes[index],
                    getBackgroundColor(index, state.notes.length)),
              ),
              itemCount: state.notes.length,
            ),
          );
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
        duration: const Duration(seconds: 2),
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

class AttachmentDownloadable extends StatefulWidget {
  const AttachmentDownloadable({
    super.key,
    this.attachment,
    this.isRemovable = false,
    this.onRemove,
    this.isImage = false,
    this.filePath,
    this.isDownloadable = true,
  });

  final Attachment? attachment;
  final String? filePath;
  final bool isRemovable;
  final void Function()? onRemove;
  final bool isDownloadable;
  final bool isImage;

  @override
  State<AttachmentDownloadable> createState() => _AttachmentDownloadableState();
}

class _AttachmentDownloadableState extends State<AttachmentDownloadable> {
  bool _isDownloading = false;

  void _setDownloadingState(bool isDownloading) {
    setState(() {
      _isDownloading = isDownloading;
    });
  }

  @override
  Widget build(BuildContext context) {
    var color = widget.isRemovable ? Colors.orangeAccent : Colors.blueAccent;
    return GestureDetector(
      onTap: () {
        if (widget.isRemovable) {
          widget.onRemove?.call();
        } else {
          if (widget.isDownloadable) downloadAttachment();
        }
      },
      child: !widget.isImage
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isDownloading
                      ? Container(
                          width: 16,
                          height: 16,
                          padding: const EdgeInsets.all(2),
                          child: CircularProgressIndicator(
                            color: color,
                            strokeWidth: 1,
                          ),
                        )
                      : Icon(
                          Icons.attach_file,
                          color: color,
                          size: 18,
                        ),
                  const SizedBox(
                    width: 4,
                  ),
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            widget.attachment?.fileName ??
                                path.basename(widget.filePath!),
                            style: context.textTheme.bodySmall
                                ?.copyWith(color: color),
                          ),
                        ),
                        if (widget.isRemovable)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.close,
                              color: color,
                              size: 16,
                            ),
                          )
                      ],
                    ),
                  )
                ],
              ),
            )
          : buildImage(),
    );
  }

  Future<void> downloadAttachment() async {
    _setDownloadingState(true);
    var localPath = widget.attachment!.filePath;
    try {
      final client = http.Client();
      final request = await client.get(Uri.parse(widget.attachment!.filePath));
      final bytes = request.bodyBytes;
      final documentDir = (await getApplicationDocumentsDirectory()).path;
      localPath = '$documentDir/${widget.attachment!.fileName}';

      if (!File(localPath).existsSync()) {
        await File(localPath).writeAsBytes(bytes);
      }
    } finally {
      OpenFilex.open(localPath);
    }
    _setDownloadingState(false);
  }

  Widget buildImage() {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(top: 8.0, right: 4.0),
        child: widget.attachment == null
            ? Image.file(
                File(widget.filePath!),
                height: 80,
                width: 80,
          fit: BoxFit.cover,
              )
            : CachedNetworkImage(
                height: 80,
                width: 80,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                fit: BoxFit.cover,
                imageUrl: widget.attachment!.filePath,
                placeholder: (context, url) => const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
      ),
      if (widget.isRemovable)
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(4),
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
      if (_isDownloading)
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 4),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        )
    ]);
  }
}
