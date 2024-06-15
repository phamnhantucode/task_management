import 'package:flutter/material.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/common/extensions/date_time.dart';
import 'package:room_master_app/common/utils/utils.dart';
import 'package:room_master_app/screens/component/task_info_card.dart';

import '../component/task_least.dart';


class StatisticProject extends StatefulWidget {
   const StatisticProject({super.key});

  @override
  State<StatisticProject> createState() => _StatisticProjectState();

}

class _StatisticProjectState extends State<StatisticProject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Statistic Project'),
          backgroundColor: context.appColors.textWhite,
          foregroundColor: context.appColors.textBlack,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // '10 Jan, 2022',
                  getCurrentTimestamp.dateWeeksMonthYearFormat,
                  style: context.textTheme.bodyMedium?.copyWith(color: context.appColors.bgGray),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.3,
                  crossAxisSpacing: 10,
                  children: [
                    TaskCardInfo(title: 'Starting', count: 12, color:Colors.blue.shade300),
                    TaskCardInfo(title: 'Running', count:18, color:Colors.orange.shade300),
                    TaskCardInfo(title: 'Completed', count:26, color:Colors.green.shade400),
                    TaskCardInfo(title: 'Cancel',count: 0, color:Colors.pink.shade300),
                  ],
                ),
                SizedBox(height: 24),
                Text(
                  'My latest task report',
                  style:  context.textTheme.bodyLarge,
                ),
                SizedBox(height: 16),
                Column(
                  children: [
                    TaskLeast(title: 'Desgin UI&UX Figma Flutter', status: 'Ongoing',value: 0.3, colorStatus:Colors.orange.shade300,),
                    TaskLeast(title: 'Develope Website Education', status: 'Done',value: 1.0,colorStatus:Colors.green.shade400,),
                    TaskLeast(title: 'Develope Website E-Commerce', status: 'Start',value: 0.1,colorStatus:Colors.blue.shade300,),
                  ],
                ),

              ],
            ),
          ),
        ),
    );
  }
}
