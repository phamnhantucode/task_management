import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/navigation/navigation.dart';
import 'package:room_master_app/screens/component/top_header/primary.dart';

class TaskDetail extends StatefulWidget {
  const TaskDetail({super.key});

  @override
  State<StatefulWidget> createState() => TaskDetailState();
}

class TaskDetailState extends State<TaskDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      _buildTitle(),
      const SizedBox(height: 20),
      Text(
        'Name of Task',
        style: context.textTheme.titleLarge,
      ),
      const SizedBox(height: 20),
      Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration:
                BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
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
          Text(
            '04 April, at 11:30',
            style: context.textTheme.labelMedium,
          )
        ],
      ),
    ])));
  }

  _buildTitle() {
    return TopHeader(
        title: 'Task detail',
        leftAction: () {
          context.go(NavigationPath.home);
        });
  }
}
