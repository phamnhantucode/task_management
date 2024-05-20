import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/models/domain/project/project.dart';
import 'package:room_master_app/screens/component/SpacerComponent.dart';
import 'package:room_master_app/screens/component/modal_list_member.dart';
import 'package:room_master_app/screens/component/tm_icon_button.dart';
import 'package:room_master_app/screens/component/top_header/primary.dart';
import 'package:room_master_app/screens/project_detail/project_detail_cubit.dart';
import 'package:room_master_app/screens/project_detail/project_detail_screen.dart';
import 'package:room_master_app/screens/task_detai_real/cubit/task_detail_cubit.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show User;

class TaskDetail extends StatefulWidget {
  const TaskDetail({super.key, required this.taskInfo});
  final Task taskInfo;
  @override
  State<StatefulWidget> createState() => TaskDetailState();
}

class TaskDetailState extends State<TaskDetail> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => TaskDetailCubit()
          ..init(widget.taskInfo.projectId.id, widget.taskInfo.id),
        child: BlocBuilder<TaskDetailCubit, TaskDetailInfoState>(
          builder: (contextInner, state) => Scaffold(
              body: SafeArea(
                  child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildTitle(),
              const SizedBox(height: 20),
              Text(
                contextInner.watch<TaskDetailCubit>().state.taskName,
                style: context.textTheme.titleLarge,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.grey[200], shape: BoxShape.circle),
                    child: Center(
                      child: Icon(
                        Icons.calendar_month,
                        size: 32,
                        color: context.appColors.buttonEnable,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('HH:mm, M/d/y')
                            .format(widget.taskInfo.startDate!),
                        style: context.textTheme.labelSmall,
                      ),
                      Text(
                        DateFormat('HH:mm, M/d/y')
                            .format(widget.taskInfo.endDate!),
                        style: context.textTheme.labelSmall,
                      ),
                    ],
                  )
                ],
              ),
              SpacerComponent.m(),
              Text(
                context.l10n.text_description,
                style: context.textTheme.labelMedium,
              ),
              Text(
                contextInner.watch<TaskDetailCubit>().state.description,
              ),
              Text(
                context.l10n.members,
                style: context.textTheme.labelMedium,
              ),
              const SizedBox(height: 10),
              buildMembers(
                  contextInner, contextInner.watch<TaskDetailCubit>().state),
            ]),
          ))),
        ));
  }

  buildMembers(BuildContext contextState, TaskDetailInfoState state) {
    onPressAdd(User user, bool isCurrentAdded) {
      contextState.read<TaskDetailCubit>().assignTaskFor(user, isCurrentAdded);
    }

    return Row(children: [
      state.assignee == null
          ? const SizedBox.shrink()
          : CircleAvatar(
              radius: 24,
              backgroundImage: CachedNetworkImageProvider(
                  state.assignee!.imageUrl ?? getAvatarUrl(1)),
            ),
      const Expanded(child: SizedBox()),
      TMIconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: contextState,
            isScrollControlled: true,
            builder: (context) {
              return ModalListMember(
                projectId: widget.taskInfo.projectId.id,
                assignee: state.assignee,
                onPressAdd: onPressAdd,
                taskId: widget.taskInfo.id,
              );
            },
          );
        },
        backgroundColor: context.appColors.buttonEnable.withAlpha(20),
      )
    ]);
  }

  _buildTitle() {
    return TopHeader(
        title: 'Task detail',
        leftAction: () {
          context.pop();
        });
  }
}
