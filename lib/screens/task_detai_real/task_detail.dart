import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/models/domain/project/project.dart';
import 'package:room_master_app/screens/component/SpacerComponent.dart';
import 'package:room_master_app/screens/component/top_header/primary.dart';

class TaskDetail extends StatefulWidget {
  const TaskDetail({super.key, required this.taskInfo});
  final Task taskInfo;
  @override
  State<StatefulWidget> createState() => TaskDetailState();
}

class TaskDetailState extends State<TaskDetail> {
  @override
  Widget build(BuildContext context) {
    print(widget.taskInfo);

    return Scaffold(
        body: SafeArea(
            child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildTitle(),
        const SizedBox(height: 20),
        Text(
          widget.taskInfo.name,
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
                  DateFormat('HH:mm, M/d/y').format(widget.taskInfo.startDate!),
                  style: context.textTheme.labelSmall,
                ),
                Text(
                  DateFormat('HH:mm, M/d/y').format(widget.taskInfo.endDate!),
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
          widget.taskInfo.description,
        ),
      ]),
    )));
  }

  _buildTitle() {
    return TopHeader(
        title: 'Task detail',
        leftAction: () {
          context.pop();
        });
  }
}
