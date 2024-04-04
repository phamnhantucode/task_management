import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/common/extensions/date_time.dart';
import 'package:room_master_app/common/utils/utils.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/component/task_container.dart';
import 'package:room_master_app/screens/component/top_header/primary.dart';

final class UpcomingTaskScreen extends StatelessWidget {
  const UpcomingTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopHeader(title: context.l10n.text_upcoming_task),
            buildDateTimeLineSection(context),
            SizedBox(
              height: 30.h,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
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
                        Container(
                          decoration: BoxDecoration(
                              color: context.appColors.buttonEnable,
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 6, vertical: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                size: 18.w,
                                color: context.appColors.textOnBtnEnable,
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              Text(
                                context.l10n.text_add_new,
                                style: context.textTheme.bodySmall?.copyWith(
                                    color: context.appColors.textOnBtnEnable),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                        child: ListView.builder(
                      itemBuilder: (context, index) =>
                          TaskContainer(context: context,
                            isShadowContainer: false,
                            title: 'Test Title',
                            content: 'Test content',
                            backgroundColor: Colors.blue.shade50,
                            iconBackgroundColor: Colors.blue.shade100,
                            contentColor: Colors.blue.shade500,
                          ),
                      itemCount: 20,
                    ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Column buildDateTimeLineSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24.h),
        Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 18.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.text_toDay,
                style: context.textTheme.displaySmall
                    ?.copyWith(color: context.appColors.textGray),
              ),
              Text(
                getCurrentTimestamp.dateWeeksMonthFormat,
                style: context.textTheme.labelLarge,
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        EasyInfiniteDateTimeLine(
          firstDate:
              getCurrentTimestamp.copyWith(year: getCurrentTimestamp.year - 1),
          focusDate: getCurrentTimestamp,
          lastDate:
              getCurrentTimestamp.copyWith(year: getCurrentTimestamp.year + 1),
          onDateChange: (selectedDate) {},
          dayProps: const EasyDayProps(
            height: 70,
          ),
          headerBuilder: (context, date) => const SizedBox.shrink(),
          itemBuilder:
              (context, dayNumber, dayName, monthName, fullDate, isSelected) =>
                  SizedBox(
            width: 40.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(dayName,
                    style: context.textTheme.bodySmall
                        ?.copyWith(color: context.appColors.textGray)),
                SizedBox(
                  height: 8,
                ),
                Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isSelected ? context.appColors.buttonEnable : null,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Text(dayNumber,
                          style: context.textTheme.bodyLarge?.copyWith(
                              color: isSelected
                                  ? context.appColors.textOnBtnEnable
                                  : null)),
                    )),
              ],
            ),
          ),
        )
      ],
    );
  }
}
