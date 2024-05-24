import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/common/utils/utils.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/component/SpacerComponent.dart';
import 'package:room_master_app/screens/component/calendar_date_picker_dialog.dart';
import 'package:room_master_app/screens/new_task/bloc/new_task_cubit.dart';

import '../../models/domain/project/project.dart';
import '../component/time_select_pop_up.dart';
import '../component/tm_text_field.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key, required this.projectId, this.isEdit = false, this.task});

  final String projectId;
  final bool isEdit;
  final Task? task;

  @override
  State<StatefulWidget> createState() => NewTaskScreenState();
}

class NewTaskScreenState extends State<NewTaskScreen> {
  late DraggableScrollableController _scrollController;
  bool _isFullScreen = false;
  double keyboardSize = 0;
  bool isSingleDate = false;
  @override
  void initState() {
    super.initState();
    _scrollController = DraggableScrollableController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() async {
    double size = _scrollController.size;
    size = double.parse(size.toStringAsFixed(2));

    if (size == 0.45 || size == 0.97) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _isFullScreen = size == 0.97;
        });
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant NewTaskScreen oldWidget) {
    keyboardSize = MediaQuery.of(context).viewInsets.bottom /
        MediaQuery.of(context).size.height;
    if (keyboardSize > 0) {
      keyboardSize -= 0.1;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewTaskCubit()..init(isEdit: widget.isEdit, task: widget.task),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: DraggableScrollableSheet(
          controller: _scrollController,
          initialChildSize: 0.45 + keyboardSize,
          snapSizes: const [0.45, 0.97],
          snap: true,
          expand: false,
          builder: (context, scrollController) => SafeArea(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SpacerComponent.s(
                      isVertical: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                                child: Text(
                              context.l10n.text_create_new_task,
                              style: context.textTheme.titleMedium,
                            )),
                          ),
                          Positioned(
                            right: 10,
                            bottom: 0,
                            top: 0,
                            child: IconButton(
                              style: const ButtonStyle(
                                padding:
                                    MaterialStatePropertyAll(EdgeInsets.all(6)),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.close),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    _buildProjectNameSection(context),
                    SizedBox(
                      height: _isFullScreen ? 16 : 0,
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
                    _buildConfirmBtn(context)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectNameSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TMTextField(
            initialText: context.read<NewTaskCubit>().state.name,
            hintText: context.l10n.text_enter_task_name,
            textStyle: context.textTheme.bodyMedium,
            borderColor: context.appColors.borderColor,
            onTextChange: (e) {
              context.read<NewTaskCubit>().taskNameChanged(e);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, List<String> categories) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: _isFullScreen
          ? Padding(
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
            )
          : const SizedBox.shrink(),
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
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: animation,
        child: child,
      ),
      reverseDuration: const Duration(milliseconds: 300),
      child: _isFullScreen
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        context.l10n.text_date_and_time,
                        style: context.textTheme.labelLarge,
                      )),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              isSingleDate = !isSingleDate;
                            });
                          },
                          icon: Icon(isSingleDate
                              ? Icons.calendar_month
                              : Icons.edit_calendar_outlined))
                    ],
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
                          context.read<NewTaskCubit>().state.startDate != null
                              ? context
                                  .read<NewTaskCubit>()
                                  .state
                                  .startDate
                                  .toString()
                              : 'Start date',
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
                                  value: [getCurrentTimestamp],
                                  onDateTimeSelected: (e) {
                                    context
                                        .read<NewTaskCubit>()
                                        .taskOnChangeDateTime(startDate: e[0]!);
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
                  SpacerComponent.m(),
                  if (!isSingleDate)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        border:
                            Border.all(color: context.appColors.borderColor),
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
                             context.read<NewTaskCubit>().state.endDate != null
                              ? context
                                  .read<NewTaskCubit>()
                                  .state
                                  .endDate
                                  .toString()
                              : 'End date',
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
                                    value: [getCurrentTimestamp],
                                    onDateTimeSelected: (e) {
                                      context
                                          .read<NewTaskCubit>()
                                          .taskOnChangeDateTime(
                                              endDate: e[0]!);
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
                              initTime: context
                                      .watch<NewTaskCubit>()
                                      .state
                                      .startDate ??
                                  getCurrentTimestamp,
                              onChange: (DateTime dateTime) {
                                context
                                    .read<NewTaskCubit>()
                                    .taskOnChangeDateTime(startDate: dateTime, isSingle: isSingleDate);
                              },
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
                                initTime: isSingleDate
                                    ? context
                                            .watch<NewTaskCubit>()
                                            .state
                                            .endDate ?? context
                                            .watch<NewTaskCubit>()
                                            .state
                                            .startDate ??
                                        getCurrentTimestamp
                                    : context
                                            .watch<NewTaskCubit>()
                                            .state
                                            .endDate ??
                                        getCurrentTimestamp,
                                onChange: (DateTime dateTime) {
                                  context
                                      .read<NewTaskCubit>()
                                      .taskOnChangeDateTime(endDate: dateTime);
                                })
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          : const SizedBox.shrink(),
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
            initialText: context.read<NewTaskCubit>().state.description,
            hintText: context.l10n.text_description,
            textStyle: context.textTheme.bodyMedium,
            borderColor: context.appColors.borderColor,
            maxLines: 3,
            onTextChange: (e) {
              context.read<NewTaskCubit>().taskDescriptionChanged(e);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmBtn(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          context.read<NewTaskCubit>().createTask(widget.projectId);
          context.pop(true);
        },
        child: Text(
          context.l10n.text_confirm,
          style: context.textTheme.titleSmall,
        ));
  }
}
