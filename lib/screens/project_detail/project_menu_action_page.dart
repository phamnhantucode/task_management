import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/blocs/authentication/authentication_cubit.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/common/utils/app_utils.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/component/dialog/alert_dialog.dart';
import 'package:room_master_app/screens/component/flushbar/flushbar_alert.dart';
import 'package:room_master_app/screens/component/tm_text_field.dart';
import 'package:room_master_app/screens/project_detail/members_page.dart';
import 'package:room_master_app/screens/project_detail/project_detail_cubit.dart';

import '../../common/assets/app_assets.dart';
import '../../common/utils/utils.dart';
import '../../domain/service/qr_action.dart';
import '../../models/dtos/user/user_dto.dart';
import '../../navigation/navigation.dart';
import '../chat/users_page.dart';
import '../component/calendar_date_picker_dialog.dart';
import '../component/dialog/qr_dialog.dart';

class ProjectMenuActionPage extends StatelessWidget {
  const ProjectMenuActionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final projectColor =
        context.watch<ProjectDetailCubit>().state.project?.color;
    final contrastColor = getContrastColor(projectColor ?? Colors.white);
    return BlocBuilder<ProjectDetailCubit, ProjectDetailState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: contrastColor),
              onPressed: () => context.pop(),
            ),
            title: Text(
              context.l10n.text_option,
              style:
                  context.textTheme.titleMedium?.copyWith(color: contrastColor),
            ),
            backgroundColor: projectColor,
          ),
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(color: Colors.grey.shade100),
              child: Column(
                children: [
                  Container(
                    color: context.appColors.defaultBgContainer,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(state.projectName,
                            style: context.textTheme.titleMedium),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildActionItem(
                                context,
                                context.l10n.text_add_member,
                                AppAssets.iconAddMembers, () async {
                              final listUsersSelected = await context
                                  .push<List<UserDto>>(NavigationPath.addMember,
                                      extra: context
                                              .read<ProjectDetailCubit>()
                                              .state
                                              .project
                                              ?.members ??
                                          []);
                              print(listUsersSelected);
                              if (listUsersSelected != null) {
                                context
                                    .read<ProjectDetailCubit>()
                                    .updateMembers(listUsersSelected, true);
                              }
                            }),
                            const SizedBox(width: 16),
                            _buildActionItem(
                                context,
                                context.l10n.text_change_theme,
                                AppAssets.iconBrush, () {
                              showModalSelectedColor(context);
                            }),
                            const SizedBox(width: 16),
                            _buildActionItem(
                                context,
                                context.l10n.text_turn_off_notification,
                                context.watch<ProjectDetailCubit>().state.projectNotification ? AppAssets.iconNotifications : AppAssets.iconNotificationsOff,
                                () {
                                  showSuccessFlushBar(context, 'This project notification have been turn off');
                                  final cubit = context.read<ProjectDetailCubit>();
                                  cubit.setProjectNotification(!cubit.state.projectNotification);
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    color: context.appColors.defaultBgContainer,
                    child: _buildListActionMemberItem(
                      context: context,
                      iconPath: AppAssets.iconNote,
                      title: context.l10n.text_take_note,
                      onTap: () {
                        showModalAddNotes(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildListActionMember(context),
                  const SizedBox(height: 16),
                  Container(
                    color: context.appColors.defaultBgContainer,
                    child: _buildListActionMemberItem(
                      context: context,
                      iconPath: AppAssets.iconDueDate,
                      title: context.l10n.text_change_project_due_date,
                      onTap: () async {
                        var cubit = context.read<ProjectDetailCubit>();
                        await TMCalendarDateTimePicker(
                            initialDate: cubit.state.project?.endDate ??
                                getCurrentTimestamp,
                            onDateTimeSelected: (e) {
                              cubit.onChangeDueDate(e ?? getCurrentTimestamp);
                            }).onShowDialog(context);
                        context.pop();
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildActionsProject(context)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionItem(
      BuildContext context, String title, String iconPath, Function() onTap) {
    return Expanded(
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(
                iconPath,
                width: 24,
                height: 24,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: context.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildListActionMember(BuildContext context) {
    return Container(
      color: context.appColors.defaultBgContainer,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildListActionMemberItem(
              context: context,
              iconPath: AppAssets.iconMembers,
              title: context.l10n.text_see_all_members,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  //add transition
                  builder: (innerContext) => MembersPage(
                    projectId:
                        context.read<ProjectDetailCubit>().state.project?.id ??
                            '',
                  ),
                ));
              },
              subTitle:
                  '(${context.read<ProjectDetailCubit>().state.project?.members.length})'),
          Divider(
            height: 1,
            indent: 60,
            color: context.appColors.borderColor,
          ),
          _buildListActionMemberItem(
            context: context,
            iconPath: AppAssets.iconAcceptUser,
            title: context.l10n.text_accept_member,
            onTap: () {
              showModalUsersRequest(context);
            },
          ),
          Divider(
            height: 1,
            indent: 60,
            color: context.appColors.borderColor,
          ),
          _buildListActionMemberItem(
              context: context,
              iconPath: AppAssets.iconQr,
              title: context.l10n.text_project_qr_invite_code,
              onTap: () {
                showQrDialog(
                    context,
                    context.l10n.text_project_qr_invite_code,
                    context.l10n.text_content_qr_project_dialog,
                    QrAction.joinProject.encode(
                        context.read<ProjectDetailCubit>().state.project?.id ??
                            ''));
              }),
        ],
      ),
    );
  }

  Widget _buildListActionMemberItem(
      {required BuildContext context,
      required String iconPath,
      required String title,
      required Function() onTap,
      String? subTitle,
      Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: SvgPicture.asset(
                iconPath,
                color: color,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Row(
                children: [
                  Text(title,
                      style:
                          context.textTheme.bodyMedium?.copyWith(color: color)),
                  subTitle != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(subTitle,
                              style: context.textTheme.bodyMedium?.copyWith(
                                  color: color?.withOpacity(0.7) ??
                                      context.appColors.textGray)),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildActionsProject(BuildContext context) {
    return Container(
      color: context.appColors.defaultBgContainer,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildListActionMemberItem(
              context: context,
              iconPath: AppAssets.iconDisable,
              color: Colors.orange,
              title: context.l10n.text_disable_project,
              onTap: () {}),
          Divider(
            height: 1,
            indent: 60,
            color: context.appColors.borderColor,
          ),
          _buildListActionMemberItem(
              context: context,
              iconPath: AppAssets.iconLeaving,
              title: context.l10n.text_leave_project,
              color: Colors.red,
              onTap: () {
                final project =
                    context.read<ProjectDetailCubit>().state.project;
                if (project != null &&
                    !isOwnerProject(
                        context.read<AuthenticationCubit>().state.user?.uid ??
                            '',
                        context.read<ProjectDetailCubit>().state.project!)) {
                  context.read<ProjectDetailCubit>().leaveProject(
                      context.read<AuthenticationCubit>().state.user?.uid);
                } else {
                  Flushbar(
                    message: context.l10n.text_owner_cannot_leave_project,
                    duration: const Duration(seconds: 1),
                  ).show(context);
                }
              }),
          Divider(
            height: 1,
            indent: 60,
            color: context.appColors.borderColor,
          ),
          _buildListActionMemberItem(
            context: context,
            iconPath: AppAssets.iconDelete,
            color: Colors.red,
            title: context.l10n.text_delete_project,
            onTap: () {
              final project = context.read<ProjectDetailCubit>().state.project;
              if (project != null &&
                  isOwnerProject(
                      context.read<AuthenticationCubit>().state.user?.uid ?? '',
                      context.read<ProjectDetailCubit>().state.project!)) {
                showAlertDialog(
                  context: context,
                  title: context.l10n.text_caution,
                  content:
                      context.l10n.text_are_you_sure_to_delete_this_project,
                  leftAction: () => context.pop(),
                  rightAction: () {
                    context.read<ProjectDetailCubit>().deleteProject();
                    context
                      ..pop()
                      ..pop()
                      ..pop();
                  },
                );
              } else {
                Flushbar(
                  message: context.l10n.text_member_cannot_delete_project,
                  duration: const Duration(seconds: 1),
                ).show(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void showModalSelectedColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext innerContext) {
        return BlocProvider.value(
          value: context.read<ProjectDetailCubit>(),
          child: const SelectColor(),
        );
      },
    );
  }

  void showModalAddNotes(BuildContext context) async {
    final note = await showDialog<String>(
      context: context,
      builder: (BuildContext innerContext) {
        return BlocProvider.value(
          value: context.read<ProjectDetailCubit>(),
          child: const AddNote(),
        );
      },
    );
    if (note != null && note.isNotEmpty) {
      context.read<ProjectDetailCubit>().addProjectNote(note);
    }
  }

  void showModalUsersRequest(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(25),
          topStart: Radius.circular(25),
        ),
      ),
      builder: (innerContext) => BlocProvider.value(
        value: context.read<ProjectDetailCubit>(),
        child: buildUsersWaitingAcceptBottomSheet(
            innerContext, [], (userAccept) {}, (userDecline) {}),
      ),
    );
  }
}

class AddNote extends StatefulWidget {
  const AddNote(
      {super.key,
      this.initialNote = '',
      this.onNoteChanged,
      this.onNoteSaved,
      this.onCancel});

  final String initialNote;

  final void Function(String)? onNoteChanged;
  final void Function()? onNoteSaved;
  final void Function()? onCancel;

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  late TextEditingController _noteController;

  @override
  void initState() {
    _noteController = TextEditingController(text: widget.initialNote);
    super.initState();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(0),
      actionsPadding: const EdgeInsets.all(12),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            context.l10n.text_cancel,
            style: context.textTheme.bodyMedium
                ?.copyWith(color: context.appColors.buttonEnable),
          ),
        ),
        TextButton(
          onPressed: () {
            context.pop(_noteController.text);
          },
          child: Text(
            context.l10n.text_save,
            style: context.textTheme.bodyMedium
                ?.copyWith(color: context.appColors.buttonEnable),
          ),
        ),
      ],
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TMTextField(
                controller: _noteController,
                initialText: widget.initialNote,
                hintText: context.l10n.text_take_note,
                onTextChange: (value) {
                  widget.onNoteChanged?.call(value);
                  _noteController.text = value;
                },
                maxLines: 5,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SelectColor extends StatefulWidget {
  const SelectColor({
    super.key,
  });

  @override
  State<SelectColor> createState() => _SelectColorState();
}

class _SelectColorState extends State<SelectColor> {
  var _color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(0),
      actionsPadding: const EdgeInsets.all(12),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
          topLeft: Radius.circular(200),
          topRight: Radius.circular(200),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            context.l10n.text_cancel,
            style: context.textTheme.bodyMedium
                ?.copyWith(color: context.appColors.buttonEnable),
          ),
        ),
        TextButton(
          onPressed: () {
            context.read<ProjectDetailCubit>().updateProjectColor(_color);
            context.pop();
          },
          child: Text(
            context.l10n.text_save,
            style: context.textTheme.bodyMedium
                ?.copyWith(color: context.appColors.buttonEnable),
          ),
        ),
      ],
      content: SingleChildScrollView(
        child: Column(
          children: [
            HueRingPicker(
              pickerColor: Colors.white,
              enableAlpha: true,
              onColorChanged: (value) {
                _color = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}
