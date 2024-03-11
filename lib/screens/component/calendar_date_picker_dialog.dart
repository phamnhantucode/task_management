import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:room_master_app/common/extensions/context.dart';

import '../../common/utils/utils.dart';

final class TMCalendarDatePicker {
  const TMCalendarDatePicker({
    this.width,
    this.firstDate,
    this.lastDate,
    this.onDateTimeSelected,
    this.calendarType,
    required this.value});

  final double? width;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final List<DateTime?> value;
  final CalendarDatePicker2Type? calendarType;
  final void Function(List<DateTime?> value)? onDateTimeSelected;

  Future<List<DateTime?>?> onShowDialog(BuildContext context) async {
    final result = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        firstDate: firstDate,
        // modePickerTextHandler: ({required monthDate}) {
        //   // String month = context.l10n.text_month_of(monthDate.month);
        //   // String year = monthDate.year.toString();
        //   // return '$month, $year';
        // },
        firstDayOfWeek: 1,
        calendarType: calendarType,
        currentDate: getCurrentTimestamp,
        selectableDayPredicate: (day) =>
            day.isAfter(getCurrentTimestamp.subtract(const Duration(days: 1))),
        controlsTextStyle:
        context.textTheme.labelMedium?.copyWith(color: context.appColors.textBlack),
        centerAlignModePicker: true,
        selectedDayTextStyle: context.textTheme.bodySmall?.copyWith(color: context.appColors.textOnBtnEnable),
        selectedDayHighlightColor: context.appColors.buttonEnable,
        selectedRangeHighlightColor: context.appColors.buttonDisable,
        cancelButtonTextStyle: context.textTheme.bodyMedium?.copyWith(color: context.appColors.buttonEnable),
        okButtonTextStyle: context.textTheme.bodyMedium?.copyWith(color: context.appColors.buttonEnable),
        buttonPadding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 12.h),
      ),
      dialogBackgroundColor: context.appColors.textOnBtnEnable,
      dialogSize: Size(0.92.sw, 0.35.sh),
      value: value,
    );
    if (result != null) {
      if (onDateTimeSelected != null) {
        onDateTimeSelected!(result);
      }
    }
    return result;
  }
}
