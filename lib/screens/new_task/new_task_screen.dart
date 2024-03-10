import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:room_master_app/common/constant.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/common/extensions/date_time.dart';
import 'package:room_master_app/common/utils/utils.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/component/calendar_date_picker_dialog.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TMTitleBar(
                title: context.l10n.text_create_new_task,
              ),
              SizedBox(
                height: 16.h,
              ),
              _buildTaskNameSection(context),
              SizedBox(
                height: 16.h,
              ),
              _buildCategorySection(context, [
                'Design',
                'Design',
                'Design',
                'Design',
                'Design',
                'Design',
                'Design',
                'Design',
                'Design',
                'Design',
                'Design',
                'Design',
                'Design'
              ]),
              _buildDateAndTimeSection(context),
              _buildDescriptionSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskNameSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.text_task_name,
            style: context.textTheme.labelLarge,
          ),
          SizedBox(
            height: 8.h,
          ),
          TMTextField(
            hintText: context.l10n.text_enter_task_name,
            textStyle: context.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, List<String> categories) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.text_category,
            style: context.textTheme.labelLarge,
          ),
          SizedBox(
            height: 8.h,
          ),
          SizedBox(
            height: 40.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) =>
                  _buildItemCategory(context, label: categories[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCategory(BuildContext context, {required String label}) {
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.only(end: 16.w),
        child: ElevatedButton(
          style: ButtonStyle(
              elevation: const MaterialStatePropertyAll(0),
              backgroundColor:
                  MaterialStatePropertyAll(context.appColors.buttonDisable),
              padding: MaterialStatePropertyAll(
                EdgeInsetsDirectional.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
              ),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r)))),
          onPressed: () {},
          child: Text(
            label,
            style: context.textTheme.bodySmall
                ?.copyWith(color: context.appColors.textBlack),
          ),
        ),
      ),
    );
  }

  Widget _buildDateAndTimeSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.text_date_and_time,
            style: context.textTheme.labelLarge,
          ),
          SizedBox(
            height: 16.h,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: context.appColors.borderColor),
            ),
            padding: EdgeInsetsDirectional.symmetric(
                vertical: 6.h, horizontal: 12.w),
            child: Row(
              children: [
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                    child: Text(
                  '05 April, Tuesday',
                  style: context.textTheme.bodyMedium
                      ?.copyWith(color: context.appColors.textGray),
                )),
                IconButton(
                    constraints: const BoxConstraints(),
                    style: ButtonStyle(
                      shape: const MaterialStatePropertyAll(CircleBorder()),
                      backgroundColor: MaterialStatePropertyAll(
                          context.appColors.buttonDisable),
                    ),
                    onPressed: () async {
                      final result = await TMCalendarDatePicker(
                          value: [getCurrentTimestamp]).onShowDialog(context);
                    },
                    icon: Icon(
                      Icons.calendar_month,
                      color: context.appColors.buttonEnable,
                      size: 18.r,
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.text_start_time,
                      style: context.textTheme.labelMedium,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    TMSelectTime(
                      initTime: getCurrentTimestamp,
                      onChange: (DateTime dateTime) {},
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 24.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.text_end_time,
                      style: context.textTheme.labelMedium,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    TMSelectTime(
                      initTime: getCurrentTimestamp,
                      onChange: (DateTime dateTime) {},
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.text_description,
            style: context.textTheme.labelLarge,
          ),
          SizedBox(
            height: 8.h,
          ),
          TMTextField(
            hintText: context.l10n.text_description,
            textStyle: context.textTheme.bodyMedium,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}

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

final class TMTextField extends StatelessWidget {
  const TMTextField({
    super.key,
    this.initialText,
    this.hintText,
    this.textStyle,
    this.maxLines,
  });

  final String? initialText;
  final String? hintText;
  final TextStyle? textStyle;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: context.appColors.borderColor)),
      padding: EdgeInsetsDirectional.only(start: 16.w),
      child: TextFormField(
        initialValue: initialText,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: textStyle?.copyWith(color: context.appColors.textGray)),
        maxLines: maxLines,
      ),
    );
  }
}

class TMTitleBar extends StatelessWidget {
  const TMTitleBar({super.key, required this.title, this.prefix, this.suffix});

  final String title;
  final Widget? prefix;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(vertical: 16.h),
      child: Row(
        children: [
          prefix ?? const SizedBox.shrink(),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: context.textTheme.bodyLarge
                    ?.copyWith(color: context.appColors.textBlack),
              ),
            ),
          ),
          suffix ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
