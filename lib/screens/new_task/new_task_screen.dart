import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/common/utils/utils.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/navigation/navigation.dart';
import 'package:room_master_app/screens/component/calendar_date_picker_dialog.dart';
import 'package:room_master_app/screens/component/top_header/primary.dart';

import '../component/time_select_pop_up.dart';
import '../component/tm_text_field.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<StatefulWidget> createState() => NewTaskScreenState();
}

class NewTaskScreenState extends State<NewTaskScreen> {
  String taskName = "";
  String description = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TopHeader(title: 'New Project', leftAction: (){
                context.go(NavigationPath.home);
              },),
              SizedBox(
                height: 16.h,
              ),
              _buildProjectNameSection(context),
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
              _buildConfirmBtn()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectNameSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Project name',
            style: context.textTheme.labelLarge,
          ),
          SizedBox(
            height: 8.h,
          ),
          TMTextField(
            hintText: context.l10n.text_enter_task_name,
            textStyle: context.textTheme.bodyMedium,
            onTextChange: (e) {
              setState(() {
                taskName = e;
              });
            },
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
                      await TMCalendarDatePicker(value: [getCurrentTimestamp])
                          .onShowDialog(context);
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
            onTextChange: (e) {
              setState(() {
                description = e;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmBtn() {
    return ElevatedButton(
        onPressed: () {
          print('conirmmd: $taskName $description');
        },
        child: Text(
          'Confirm',
          style: context.textTheme.titleSmall,
        ));
  }
}