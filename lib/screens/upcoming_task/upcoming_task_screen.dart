import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:room_master_app/blocs/authentication/authentication_cubit.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/component/SpacerComponent.dart';
import 'package:room_master_app/screens/component/task_container.dart';
import 'package:room_master_app/screens/upcoming_task/bloc/upcoming_task_cubit.dart';

final class UpcomingTaskScreen extends StatelessWidget {
  const UpcomingTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpcomingTaskCubit()
        ..init(context.read<AuthenticationCubit>().state.user?.uid ?? ''),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(context.l10n.text_upcoming_task),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.more_vert,
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildDateTimeLineSection(context),
                SizedBox(
                  height: 30.h,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                    ),
                    padding: const EdgeInsets.only(top: 32),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.l10n.text_schedule,
                                style: context.textTheme.labelLarge,
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                          color: context.appColors.buttonEnable,
                                          width: 2),
                                    ),
                                    child: Text(
                                      String.fromCharCode(Icons.add.codePoint),
                                      style: TextStyle(
                                        inherit: false,
                                        color: context.appColors.buttonEnable,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: Icons
                                            .space_dashboard_outlined
                                            .fontFamily,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  Text(
                                    context.l10n.text_add_new_project,
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(
                                            color:
                                                context.appColors.buttonEnable,
                                            fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SpacerComponent.l(),
                          buildListTask(context)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget buildListTask(BuildContext context) {
    return BlocBuilder<UpcomingTaskCubit, UpcomingTaskState>(
      builder: (context, state) {
        if (state.isLoadingList) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) =>
                    TaskContainer2(task: state.selectedDateTasks[index]),
                itemCount: state.selectedDateTasks.length,
              ));
        }
      },
    );
  }

  Column buildDateTimeLineSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24.h),
        EasyDateTimeLine(
          initialDate: DateTime.now(),
          onDateChange: (selectedDate) {
            context.read<UpcomingTaskCubit>().changeSelectedDate(selectedDate);
          },
          headerProps: const EasyHeaderProps(
            monthPickerType: MonthPickerType.switcher,
            dateFormatter: DateFormatter.fullDateDMY(),
          ),
          activeColor: Colors.blue.shade200,
          dayProps: EasyDayProps(
            dayStructure: DayStructure.dayStrDayNum,
            todayHighlightStyle: TodayHighlightStyle.withBackground,
            todayHighlightColor: Colors.blue.shade50,
          ),
        ),
      ],
    );
  }
}
