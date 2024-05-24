import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:room_master_app/screens/project_detail/project_detail_screen.dart';
import 'package:room_master_app/screens/task_detai_real/cubit/task_detail_cubit.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show User;

import '../../models/dtos/user/user_dto.dart';

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
              body: SingleChildScrollView(
            child: SafeArea(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(),
                    const SizedBox(height: 20),
                    Text(
                      contextInner.watch<TaskDetailCubit>().state.taskName,
                      style: context.textTheme.titleLarge,
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 25),
                    Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text(
                                'Start Date ',
                                style: context.textTheme.labelMedium,
                              ),
                            ),
                            Text(
                                DateFormat('HH:mm, M/d/y')
                                    .format(widget.taskInfo.startDate!),
                                style: context.textTheme.bodyMedium),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 22),
                              child: Text(
                                'Due Date ',
                                style: context.textTheme.labelMedium,
                              ),
                            ),
                            Text(
                                DateFormat('HH:mm, M/d/y')
                                    .format(widget.taskInfo.endDate!),
                                style: context.textTheme.bodyMedium),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 55),
                              child: Text(
                                'Status',
                                style: context.textTheme.labelMedium,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'On Progress',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Assign',
                          style: context.textTheme.labelMedium,
                        ),
                        const SizedBox(
                          width: 55,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAssigneeAvatar(
                                'Anh Quan',
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwyXpojRvumpsdxXiNOZCtBkU6kVb9zjbScg&usqp=CAU',
                                context),
                            _buildAssigneeAvatar(
                                'CassanoQ',
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwyXpojRvumpsdxXiNOZCtBkU6kVb9zjbScg&usqp=CAU',
                                context),
                            _buildAssigneeAvatar(
                                'JustQuan',
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwyXpojRvumpsdxXiNOZCtBkU6kVb9zjbScg&usqp=CAU',
                                context),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SpacerComponent.m(),
                    Text(
                      context.l10n.text_description,
                      style: context.textTheme.labelMedium,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      contextInner.watch<TaskDetailCubit>().state.description,
                      textAlign: TextAlign.justify,
                      style: context.textTheme.bodyMedium?.copyWith(color: context.appColors.colorDarkGray,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      context.l10n.members,
                      style: context.textTheme.labelMedium,
                    ),
                    const SizedBox(height: 10),
                    // buildMembers(contextInner,
                    //     contextInner.watch<TaskDetailCubit>().state),
                    const SizedBox(height: 10),
                    Text(
                      'Comments',
                      style: context.textTheme.labelMedium,
                    ),
                    SpacerComponent.m(),
                     Row(
                       crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwyXpojRvumpsdxXiNOZCtBkU6kVb9zjbScg&usqp=CAU'),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5,top: 2),
                              child: Text('Nguyen Anh Quan',style: context.textTheme.bodyMedium),
                            ),
                            SizedBox(
                              width: 330, // <-- TextField width
                              height: 120, // <-- TextField height
                              child: TextField(
                                maxLines: null,
                                expands: true,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.attach_file) ,
                                  filled: true,
                                  fillColor: Colors.white70,
                                  hintText: 'Type a comment.....',
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                ),
                                ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ]),
            )),
          )),
        ));
  }

  // buildMembers(BuildContext contextState, TaskDetailInfoState state) {
  //   onPressAdd(UserDto user, bool isCurrentAdded) {
  //     contextState.read<TaskDetailCubit>().assignTaskFor(user, isCurrentAdded);
  //   }
  //
  //   return Row(children: [
  //     state.assignee == null
  //         ? const SizedBox.shrink()
  //         : CircleAvatar(
  //             radius: 24,
  //             backgroundImage: CachedNetworkImageProvider(
  //                 state.assignee!.imageUrl ?? getAvatarUrl(1)),
  //           ),
  //     const Expanded(child: SizedBox()),
  //     TMIconButton(
  //       icon: const Icon(Icons.add),
  //       onPressed: () {
  //         showModalBottomSheet(
  //           context: contextState,
  //           isScrollControlled: true,
  //           builder: (context) {
  //             return ModalListMember(
  //               projectId: widget.taskInfo.projectId.id,
  //               assignee: state.assignee,
  //               onPressAdd: onPressAdd,
  //               taskId: widget.taskInfo.id,
  //             );
  //           },
  //         );
  //       },
  //       backgroundColor: context.appColors.buttonEnable.withAlpha(20),
  //     )
  //   ]);
  // }

  _buildTitle() {
    return TopHeader(
        title: 'Task detail',
        leftAction: () {
          context.pop();
        },
    );
  }
}

Widget _buildAssigneeAvatar(
    String name, String imageUrl, BuildContext context) {
  return Row(
    children: [
      Container(
        width: 30,
        height: 30,
        child: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
      ),
      const SizedBox(height: 4),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          name,
          style: context.textTheme.bodyMedium,
        ),
      ),
    ],
  );
}
