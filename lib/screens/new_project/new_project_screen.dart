import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/common/extensions/date_time.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/component/SpacerComponent.dart';
import 'package:room_master_app/screens/new_project/bloc/new_project_bloc.dart';

import '../../common/utils/utils.dart';
import '../component/calendar_date_picker_dialog.dart';
import '../component/time_select_pop_up.dart';
import '../component/tm_elevated_button.dart';
import '../component/tm_text_field.dart';

class NewProjectScreen extends StatelessWidget {
  const NewProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewProjectBloc(),
      child: BlocListener<NewProjectBloc, NewProjectState>(
        listener: (context, state) {
          if (state.status == NewProjectStatus.success) {
            Navigator.pop(context);
          } else {
            if (state.status == NewProjectStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.text_error_create_project),
                ),
              );
            }
          }
          context.read<NewProjectBloc>().add(const CleanNewProject());
        },
        child: Builder(builder: (context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: context.mediaQuery.viewInsets.bottom,
                ),
                child: Column(
                  children: [
                    SpacerComponent.l(
                      isVertical: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              context.l10n.text_create_project,
                              style: context.textTheme.labelLarge,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 32, right: 32, top: 16, bottom: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProjectNameSection(context),
                          SpacerComponent.m(
                            isVertical: true,
                          ),
                          _buildDescriptionSection(context),
                          SpacerComponent.m(
                            isVertical: true,
                          ),
                          _buildDateAndTimeSection(context),

                          SpacerComponent.m(),
                          _buildConfirmBtn(context),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildProjectNameSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TMTextField(
          hintText: context.l10n.text_enter_project_name,
          textStyle: context.textTheme.bodyMedium,
          onTextChange: (e) {
            context.read<NewProjectBloc>().add(NewProjectNameChanged(e));
          },
          borderColor: context.appColors.borderColor,
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.text_description,
          style: context.textTheme.labelMedium,
        ),
        SizedBox(
          height: 8.h,
        ),
        TMTextField(
          hintText: context.l10n.text_description,
          textStyle: context.textTheme.bodyMedium,
          maxLines: 3,
          onTextChange: (e) {
            context.read<NewProjectBloc>().add(NewProjectDescriptionChanged(e));
          },
          borderColor: context.appColors.borderColor,
        ),
      ],
    );
  }


  Widget _buildDateAndTimeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.text_end_date,
          style: context.textTheme.labelMedium,
        ),
        SizedBox(
          height: 8.h,
        ),
        Row(
          children: [
            Expanded(
              flex: 6,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: context.appColors.borderColor),
                ),
                padding: EdgeInsetsDirectional.symmetric(
                    vertical: 3.h),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(context.watch<NewProjectBloc>().state.endDate?.dateWeeksMonthFormat ?? getCurrentTimestamp.dateWeeksMonthFormat,
                            style: context.textTheme.bodyMedium
                                ?.copyWith(color: context.appColors.textGray),
                          )),
                      IconButton(
                          constraints: const BoxConstraints(),
                          style: ButtonStyle(
                            shape: const MaterialStatePropertyAll(
                                CircleBorder()),
                            backgroundColor: MaterialStatePropertyAll(
                                context.appColors.buttonDisable),
                          ),

                          onPressed: () async {
                            await TMCalendarDatePicker(
                                value: [context.read<NewProjectBloc>().state.endDate ?? getCurrentTimestamp],
                                onDateTimeSelected: (e) {
                                  log('Go here $e');
                                  context.read<NewProjectBloc>().add(DueDateChange(e.first ?? getCurrentTimestamp));
                                }).onShowDialog(context);
                          },
                          icon: Icon(
                            Icons.calendar_month,
                            color: context.appColors.buttonEnable,
                            size: 18.r,
                          )),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4,),
            Expanded(
              flex: 3,
              child: TMSelectTime(
                initTime: context
                    .watch<NewProjectBloc>()
                    .state
                    .endDate ??
                    getCurrentTimestamp,
                onChange: (DateTime dateTime) {
                  context.read<NewProjectBloc>().add(DueTimeChange(dateTime));
                },
              ),
            )

          ],
        ),
      ],
    );
  }

  Widget _buildConfirmBtn(BuildContext context) {
    return TMElevatedButton(
      height: 50,
      label: context.l10n.text_confirm,
      borderRadius: 16,
      style: context.textTheme.labelLarge
          ?.copyWith(color: context.appColors.textWhite),
      color: context.appColors.buttonEnable,
      onPressed: () {
        context.read<NewProjectBloc>().add(const NewProjectConfirm());
      },
    );
  }
}
