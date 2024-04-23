import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:room_master_app/common/extensions/context.dart';

class TaskWidget extends StatelessWidget {
  final String taskName;
  final String imageUrl;
  final String time;

  const TaskWidget({super.key, required this.taskName, required this.imageUrl, required this.time});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24, left: 4, right: 4),
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: context.appColors.borderColor,
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -5), // Moves shadow to the top
          ),
          // Bottom shadow
          BoxShadow(
            color: context.appColors.borderColor,
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 5), // Moves shadow to the bottom
          ),
        ],
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.network(
                imageUrl,
                width: 80,
                height: 80,
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    taskName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(time),
                ],
              )
            ],
          ),
          IconButton(onPressed: () => {}, icon: Icon(Icons.arrow_forward_ios))
        ],
      ),
    );
  }
  
}