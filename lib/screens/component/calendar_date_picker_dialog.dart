import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:room_master_app/common/extensions/context.dart';

import '../../common/utils/utils.dart';

final class TMCalendarDatePicker {
  const TMCalendarDatePicker(
      {this.width,
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
        controlsTextStyle: context.textTheme.labelMedium
            ?.copyWith(color: context.appColors.textBlack),
        centerAlignModePicker: true,
        selectedDayTextStyle: context.textTheme.bodySmall
            ?.copyWith(color: context.appColors.textOnBtnEnable),
        selectedDayHighlightColor: context.appColors.buttonEnable,
        selectedRangeHighlightColor: context.appColors.buttonDisable,
        cancelButtonTextStyle: context.textTheme.bodyMedium
            ?.copyWith(color: context.appColors.buttonEnable),
        okButtonTextStyle: context.textTheme.bodyMedium
            ?.copyWith(color: context.appColors.buttonEnable),
        buttonPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
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

//create class TMDateTimePicker using omni_datetime_picker
final class TMCalendarDateTimePicker {
  const TMCalendarDateTimePicker({
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.onDateTimeSelected,
  });

  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;
  final void Function(DateTime? value)? onDateTimeSelected;

  Future<DateTime?> onShowDialog(BuildContext context) async {
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      initialDate: initialDate ?? getCurrentTimestamp,
      firstDate:
          firstDate ?? getCurrentTimestamp.subtract(const Duration(days: 3652)),
      lastDate: lastDate ??
          getCurrentTimestamp.add(
            const Duration(days: 3652),
          ),
      is24HourMode: true,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
    );
    if (dateTime != null) {
      if (onDateTimeSelected != null) {
        onDateTimeSelected!(dateTime);
      }
    }
    return dateTime;
  }
}
