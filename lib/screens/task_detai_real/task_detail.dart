import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/blocs/authentication/authentication_cubit.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/common/extensions/date_time.dart';
import 'package:room_master_app/common/utils/utils.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/component/SpacerComponent.dart';
import 'package:room_master_app/screens/component/flushbar/flushbar_alert.dart';
import 'package:room_master_app/screens/component/tm_text_field.dart';
import 'package:room_master_app/screens/task_detai_real/cubit/task_detail_cubit.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../domain/service/file_picker_service.dart';
import '../../models/dtos/project/project.dart';
import '../../models/enum/image_picker_type.dart';
import '../component/bottomsheet/upload_attachment_page.dart';
import '../project_detail/project_detail_screen.dart';

class TaskDetail extends StatelessWidget {
  const TaskDetail({
    super.key,
    required this.taskId,
    required this.projectId,
  });

  final String taskId;
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => TaskDetailCubit()..init(projectId, taskId),
        child: Builder(builder: (context) {
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  context.l10n.task_detail,
                  style: context.textTheme.titleSmall,
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: SafeArea(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          context.watch<TaskDetailCubit>().state.taskName,
                          style: context.textTheme.titleLarge
                              ?.copyWith(fontSize: 28),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 25),
                        buildDetailTask(context),
                        const SizedBox(height: 16),
                        buildAssignees(context),
                        buildDescription(context),
                        const SizedBox(
                          height: 8,
                        ),
                        buildComments(context)
                      ]),
                )),
              ));
        }));
  }

  Column buildComments(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comments',
          style: context.textTheme.labelMedium,
        ),
        SpacerComponent.s(),
        Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 35,
                    width: 35,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(context
                              .read<AuthenticationCubit>()
                              .state
                              .user
                              ?.photoURL ??
                          ''),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color:
                                context.appColors.buttonEnable.withOpacity(.8)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TMTextField(
                              borderColor: Colors.transparent,
                              maxLines: 2,
                              textStyle: context.textTheme.bodySmall,
                              onTextChange: (content) => context
                                  .read<TaskDetailCubit>()
                                  .onChangeComment(content),
                            ),
                            SpacerComponent.s(),
                            BlocBuilder<TaskDetailCubit, TaskDetailInfoState>(
                              builder: (context, state) {
                                if (state.attachmentPaths.isNotEmpty) {
                                  final imageAttachments = state.attachmentPaths
                                      .where((attachment) =>
                                          isImageFile(attachment))
                                      .toList();
                                  final otherAttachments = state.attachmentPaths
                                      .where((attachment) =>
                                          !isImageFile(attachment))
                                      .toList();
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [
                                            for (var n = 0;
                                                n < imageAttachments.length;
                                                n++)
                                              AttachmentDownloadable(
                                                isRemovable: true,
                                                isDownloadable: false,
                                                filePath: imageAttachments[n],
                                                isImage: true,
                                                onRemove: () {
                                                  context
                                                      .read<TaskDetailCubit>()
                                                      .removeAttachment(
                                                          imageAttachments[n]);
                                                },
                                              ),
                                          ],
                                        ),
                                        SpacerComponent.s(),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [
                                            for (var n = 0;
                                                n < otherAttachments.length;
                                                n++)
                                              AttachmentDownloadable(
                                                filePath: otherAttachments[n],
                                                isDownloadable: false,
                                                isRemovable: true,
                                                onRemove: () {
                                                  context
                                                      .read<TaskDetailCubit>()
                                                      .removeAttachment(
                                                          otherAttachments[n]);
                                                },
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.attach_file,
                                    size: 22,
                                  ),
                                ),
                                onTap: () {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    builder: (BuildContext innerContext) =>
                                        UploadAttachmentPage(
                                      onImageSelection: () async {
                                        final state = context
                                            .read<TaskDetailCubit>()
                                            .state;
                                        final imagePath = await FileService
                                            .instance
                                            .imageSelection(
                                                ImagePickerType.gallery);
                                        if (imagePath != null) {
                                          if (state.attachmentPaths
                                              .contains(imagePath)) {
                                            showAlertFlushBar(context,
                                                'This image is already added');
                                          } else {
                                            context
                                                .read<TaskDetailCubit>()
                                                .handleImageSelection(
                                                    imagePath);
                                          }
                                        }
                                        context.pop();
                                      },
                                      onFileSelection: () async {
                                        final state = context
                                            .read<TaskDetailCubit>()
                                            .state;
                                        final filePath = await FileService
                                            .instance
                                            .fileSelection(FileType.any);
                                        if (filePath != null) {
                                          if (state.attachmentPaths
                                              .contains(filePath)) {
                                            showAlertFlushBar(context,
                                                'This file is already added');
                                          } else {
                                            context
                                                .read<TaskDetailCubit>()
                                                .handleFileSelection(filePath);
                                          }
                                        }
                                        context.pop();
                                      },
                                      onCancel: () {
                                        context.pop();
                                      },
                                    ),
                                  );
                                },
                              ),
                              GestureDetector(
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.send,
                                    size: 22,
                                  ),
                                ),
                                onTap: () {
                                  context.read<TaskDetailCubit>().addComment(
                                      userId: context
                                              .read<AuthenticationCubit>()
                                              .state
                                              .user
                                              ?.uid ??
                                          '',
                                      taskId: taskId,
                                      projectId: projectId);
                                },
                              ),
                            ],
                          ),
                        )
                      ]),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 500,
                child: BlocBuilder<TaskDetailCubit, TaskDetailInfoState>(
                  builder: (context, state) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final comment = state.comments[index];
                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(context
                                            .read<AuthenticationCubit>()
                                            .state
                                            .user
                                            ?.photoURL ??
                                        ''),
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: state.project?.color.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              comment.author.firstName ?? '',
                                              style:
                                                  context.textTheme.bodySmall,
                                            ),
                                            Text(
                                              timeago.format(comment.createdAt),
                                              style: context.textTheme.bodySmall
                                                  ?.copyWith(
                                                      color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          color: Colors.grey.shade200,
                                          height: 5,
                                        ),
                                        if (comment.content.isEmpty)
                                          const SizedBox.shrink()
                                        else
                                          Text(
                                            comment.content,
                                            style: context.textTheme.bodySmall?.copyWith(
                                                color: Colors.grey,
                                            fontStyle: FontStyle.italic,),
                                          ),
                                        Builder(
                                          builder: (context) {
                                            if (comment
                                                .attachments.isNotEmpty) {
                                              final imageAttachments = comment
                                                  .attachments
                                                  .where((attachment) =>
                                                      isImageFile(
                                                          attachment.fileName))
                                                  .toList();
                                              final otherAttachments = comment
                                                  .attachments
                                                  .where((attachment) =>
                                                      !isImageFile(
                                                          attachment.fileName))
                                                  .toList();
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Wrap(
                                                    spacing: 8,
                                                    runSpacing: 8,
                                                    children: [
                                                      for (var n = 0;
                                                          n <
                                                              imageAttachments
                                                                  .length;
                                                          n++)
                                                        AttachmentDownloadable(
                                                          attachment:
                                                              imageAttachments[
                                                                  n],
                                                          isRemovable: false,
                                                          isImage: true,
                                                        ),
                                                    ],
                                                  ),
                                                  SpacerComponent.s(),
                                                  Wrap(
                                                    spacing: 8,
                                                    runSpacing: 8,
                                                    children: [
                                                      for (var n = 0;
                                                          n <
                                                              otherAttachments
                                                                  .length;
                                                          n++)
                                                        AttachmentDownloadable(
                                                          attachment:
                                                              otherAttachments[
                                                                  n],
                                                          isRemovable: false,
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            }
                                            return const SizedBox.shrink();
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        );
                      },
                      itemCount: state.comments.length,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column buildDescription(BuildContext context) {
    return Column(
      children: [
        Text(
          context.l10n.text_description,
          style: context.textTheme.labelMedium,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          context.watch<TaskDetailCubit>().state.description,
          textAlign: TextAlign.justify,
          style: context.textTheme.bodyMedium?.copyWith(),
        ),
      ],
    );
  }

  Column buildAssignees(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.text_assignees,
          style: context.textTheme.labelMedium,
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 100,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var assignee
                    in context.watch<TaskDetailCubit>().state.assignees ?? [])
                  Builder(builder: (context) {
                    return _buildAssigneeAvatar(assignee.firstName ?? '',
                        assignee.imageUrl ?? '', context);
                  }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row buildDetailTask(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.text_start_date,
                style: context.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                context.l10n.text_due_date,
                style: context.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'Status',
                style: context.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        IntrinsicWidth(
          child: Column(
            children: [
              Text(
                  (context.watch<TaskDetailCubit>().state.startDate ??
                          getCurrentTimestamp)
                      .dateWeeksMonthYearFormat,
                  style: context.textTheme.bodyMedium),
              const SizedBox(
                height: 8,
              ),
              Text(
                  (context.watch<TaskDetailCubit>().state.endDate ??
                          getCurrentTimestamp)
                      .dateWeeksMonthYearFormat,
                  style: context.textTheme.bodyMedium),
              const SizedBox(
                height: 8,
              ),
              BlocBuilder<TaskDetailCubit, TaskDetailInfoState>(
                builder: (context, state) {
                  return DropdownButtonHideUnderline(
                      child: DropdownButton2<TaskStatus>(
                        onChanged: (value) {
                          if (value != null) {
                            context.read<TaskDetailCubit>().changeTaskStatus(value);
                          }
                        },
                    isExpanded: true,
                        buttonStyleData: ButtonStyleData(
                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                        ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      offset: const Offset(0, 0),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(40),
                        thickness: MaterialStateProperty.all(6),
                        thumbVisibility: MaterialStateProperty.all(true),
                      ),
                    ),
                    items: TaskStatus.values.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Container(
                          height: 38,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: e.color ?? Colors.black),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                                e.getLocalizationText(context) ?? '',
                                style: context.textTheme.bodySmall?.copyWith(
                                    color: e.color ?? Colors.black)),
                          ),
                        ),
                      );
                    }).toList(),
                    value: state.status,
                    hint: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: state.status?.color ?? Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                          state.status?.getLocalizationText(context) ?? '',
                          style: context.textTheme.bodySmall?.copyWith(
                              color: state.status?.color ?? Colors.black)),
                    ),
                  ));
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildAssigneeAvatar(
      String name, String imageUrl, BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: context.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
