import 'package:flutter/material.dart';
import 'package:room_master_app/common/extensions/context.dart';

class TaskCardInfo extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const TaskCardInfo(
      {super.key,
      required this.title,
      required this.count,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title',
            style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w300,
                color: context.appColors.textWhite),
          ),
          Text(
            '$count task',
            style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w300,
                color: context.appColors.textWhite),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.arrow_forward, color: Colors.white),
            ],
          )
        ],
      ),
    );
  }
}
