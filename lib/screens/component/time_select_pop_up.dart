import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/common/extensions/date_time.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

import '../../common/constant.dart';

final class TMSelectTime extends StatelessWidget {
  const TMSelectTime({
    super.key,
    required this.initTime,
    required this.onChange,
  });

  final DateTime initTime;
  final void Function(DateTime dateTime) onChange;

  @override
  Widget build(BuildContext context) {
    return TimePickerSpinnerPopUp(
      onChange: onChange,
      initTime: initTime,
      textStyle: context.textTheme.bodyMedium,
      timeFormat: AppConstants.timeFormat,
      actionButtonPadding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 12.h),
      isCancelTextLeft: true,
      cancelTextStyle: context.textTheme.bodyMedium?.copyWith(color: context.appColors.buttonEnable),
      confirmTextStyle: context.textTheme.bodyMedium?.copyWith(color: context.appColors.buttonEnable),
      timeWidgetBuilder: (time) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: context.appColors.borderColor),
        ),
        padding:
        EdgeInsetsDirectional.symmetric(vertical: 16.h, horizontal: 24.w),
        child: Row(
          children: [
            Expanded(child: Text(time.timeFormat)),
            Icon(
              Icons.keyboard_arrow_down,
              color: context.appColors.buttonEnable,
            ),
          ],
        ),
      ),
    );
  }
}