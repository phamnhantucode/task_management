import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/common/utils/utils.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/component/SpacerComponent.dart';
import 'package:room_master_app/screens/component/calendar_date_picker_dialog.dart';
import 'package:room_master_app/screens/new_task/bloc/description_generate/bool_cubit.dart';
import 'package:room_master_app/screens/new_task/bloc/new_task_cubit.dart';

import '../../models/domain/project/project.dart';
import '../component/time_select_pop_up.dart';
import '../component/tm_text_field.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen(
      {super.key, required this.projectId, this.isEdit = false, this.task});

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
      create: (context) =>
          NewTaskCubit()..init(isEdit: widget.isEdit, task: widget.task),
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
    );
  }

  Widget _buildProjectNameSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
              padding: EdgeInsetsDirectional.only(start: 24.w),
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
              padding: const EdgeInsets.all(24.0),
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
                                          .taskOnChangeDateTime(endDate: e[0]!);
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
                                    .taskOnChangeDateTime(
                                        startDate: dateTime,
                                        isSingle: isSingleDate);
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
                                            .endDate ??
                                        context
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
    return const TFieldTaskDescription();
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

class TFieldTaskDescription extends StatefulWidget {
  const TFieldTaskDescription({super.key});

  @override
  State<TFieldTaskDescription> createState() => _TFieldTaskDescriptionState();
}

class _TFieldTaskDescriptionState extends State<TFieldTaskDescription> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BoolCubit(),
      child: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: PortalTarget(
            visible: context.watch<BoolCubit>().state,
            anchor: const Aligned(
              follower: Alignment.bottomLeft,
              target: Alignment.topLeft,
            ),
            portalFollower: _buildAIDescriptionGeneration(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                  Stack(children: [
                    BlocBuilder<BoolCubit, bool>(builder: (context, state) {
                      print(context.read<NewTaskCubit>().state.description);
                      return TMTextField(
                        controller: _controller,
                        minLines: 3,
                        maxLines: 5,
                        initialText:
                        context.read<NewTaskCubit>().state.description,
                        hintText: context.l10n.text_description,
                        textStyle: context.textTheme.bodyMedium,
                        borderColor: context.appColors.borderColor,
                        onTextChange: (e) {
                          context.read<NewTaskCubit>().taskDescriptionChanged(e);
                        },
                      );
                    },),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: () {
                            context.read<BoolCubit>().toggle();
                          },
                          icon: const Icon(
                            Icons.generating_tokens_rounded,
                            color: Colors.lightBlue,
                          ),
                        ),
                      ),
                    )
                  ]),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAIDescriptionGeneration(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 150,
        maxWidth: MediaQuery.of(context).size.width,
        minHeight: 100,
        minWidth: MediaQuery.of(context).size.width,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Container(
          decoration: BoxDecoration(
            color: context.appColors.defaultBgContainer,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: context.appColors.textBlack.withOpacity(0.1),
                blurRadius: 3,
                offset: const Offset(0, 1),
              )
            ],
          ),
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              child: TaskDescriptionGenerativeAI(
                projectName: context.read<NewTaskCubit>().state.projectId ?? '',
                taskName: context.read<NewTaskCubit>().state.name,
                insufficiencyDescription:
                context.read<NewTaskCubit>().state.description,
                getDescriptionGenerated: (description) {
                  context.read<BoolCubit>().setFalse();
                  context
                      .read<NewTaskCubit>()
                      .taskDescriptionChanged(description);
                  setState(() {
                    _controller.text = description;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class TaskDescriptionGenerativeAI extends StatefulWidget {
  const TaskDescriptionGenerativeAI(
      {super.key,
      required this.projectName,
      required this.taskName,
      required this.insufficiencyDescription,
      required this.getDescriptionGenerated});

  final String projectName;
  final String taskName;
  final String insufficiencyDescription;
  final void Function(String description) getDescriptionGenerated;

  @override
  State<TaskDescriptionGenerativeAI> createState() =>
      _TaskDescriptionGenerativeAIState();
}

class _TaskDescriptionGenerativeAIState
    extends State<TaskDescriptionGenerativeAI>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  Content initialContent = Content(
    parts: [
      Parts(
        text: 'I will give you this format example: '
            'project: "Project Name", '
            'task: "Task Name", '
            'insufficientDescription: "Description of the task", '
            'And your response should be the long description of the task. It is the text of the task description.'
            'For example, if the insufficientDescription of task is "ouline red", the response should be "Button with red outline".',
      )
    ],
    role: 'user',
  );
  final gemini = Gemini.instance;
  String _descriptionGenerated = '';

  @override
  void initState() {
    _generateDescription();
    super.initState();
  }

  void _generateDescription() async {
    setState(() {
      _isLoading = true;
    });
    final result = await gemini.chat([
      initialContent,
      Content(parts: [
        Parts(
            text: 'project: "${widget.projectName}", '
                'task: "${widget.taskName}", '
                'insufficientDescription: "${widget.insufficiencyDescription}" ')
      ], role: 'user')
    ]);
    setState(() {
      _isLoading = false;
      _descriptionGenerated = result?.output ?? 'No response from the server';
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.getDescriptionGenerated(_descriptionGenerated);
      },
      child: Center(
        child: _isLoading
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Generating description...')
                ],
              )
            : Text(_descriptionGenerated),
      ),
    );
  }
}
