import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_master_app/blocs/authentication/authentication_cubit.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/common/utils/utils.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/component/task_container.dart';
import 'package:room_master_app/screens/listing/list_tasks/bloc/list_tasks_cubit.dart';

import '../../../models/dtos/project/project.dart';

class ListTasksScreen extends StatelessWidget {
  const ListTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListTasksCubit()
        ..init(context.read<AuthenticationCubit>().state.user?.uid ?? ''),
      child: BlocBuilder<ListTasksCubit, ListTasksState>(
        builder: (context, state) {
          return Scaffold(
              backgroundColor: Colors.grey.shade200,
              appBar: AppBar(
                backgroundColor: context.appColors.defaultBgContainer,
                title: Text(context.l10n.text_projects),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ],
              ),
              body: CustomScrollView(slivers: [
                SliverPersistentHeader(
                  delegate: ListAction(
                    onSearch: (value) =>
                        context.read<ListTasksCubit>().searchTask(value),
                    onSort: (value) =>
                        context.read<ListTasksCubit>().sortTask(value),
                    onFilter: (value) =>
                        context.read<ListTasksCubit>().filterTask(value),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final task = state.taskCopy[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TaskContainer2(task: task),
                      );
                    },
                    childCount: state.taskCopy.length,
                  ),
                )
              ]));
        },
      ),
    );
  }
}

class ListAction extends SliverPersistentHeaderDelegate {
  const ListAction({
    this.onSearch,
    this.onSort,
    this.onFilter,
  });

  final void Function(String value)? onSearch;
  final void Function(TaskSortBy value)? onSort;
  final void Function(List<TaskStatus> value)? onFilter;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: context.appColors.defaultBgContainer,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(child: tfSearch(context)),
            IconButton(
              icon: const Icon(Icons.sort),
              onPressed: () {
                buildModal<TaskSortBy>(
                    context: context,
                    title: context.l10n.text_sort_by,
                    current: context.read<ListTasksCubit>().state.shortBy,
                    options: TaskSortBy.values,
                    getText: (value) => value.getLocalizationText(context),
                    onSelected: (value) => onSort?.call(value));
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                showModalBottomSheet<List<TaskStatus>>(
                  context: context,
                  builder: (innerContext) {
                    return BlocProvider.value(
                      value: context.read<ListTasksCubit>(),
                      child: BlocBuilder<ListTasksCubit, ListTasksState>(
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                            child: ListView(
                              children: TaskStatus.values
                                  .map((status) => Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: state.filterByStatuses
                                                  .contains(status)
                                              ? status.color.withOpacity(0.1)
                                              : context.appColors.defaultBgContainer,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                              color: status.color,
                                              width: 1),
                                        ),
                                        child: CheckboxListTile(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16)),
                                          activeColor: status.color.withOpacity(0.3),
                                          checkColor: getContrastColor(status.color),
                                          title: Text(
                                            status.getLocalizationText(context),
                                            style: context.textTheme.bodySmall?.copyWith(
                                            ),
                                          ),
                                          value: state.filterByStatuses
                                              .contains(status),
                                          onChanged: (value) {
                                            if (value ?? false) {
                                              onFilter?.call([
                                                ...state.filterByStatuses,
                                                status
                                              ]);
                                            } else {
                                              onFilter?.call(state
                                                  .filterByStatuses
                                                  .where((element) =>
                                                      element != status)
                                                  .toList());
                                            }
                                          },
                                        ),
                                      ))
                                  .toList(),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void buildModal<T>({
    required BuildContext context,
    required String title,
    required T current,
    required List<T> options,
    required String Function(T) getText,
    required void Function(T)? onSelected,
  }) {
    CupertinoActionSheetAction buildAction(T option) {
      return CupertinoActionSheetAction(
        onPressed: () {
          onSelected?.call(option);
          Navigator.pop(context);
        },
        child: Text(
          getText(option),
          style: context.textTheme.bodyLarge?.copyWith(
              color: current == option
                  ? context.appColors.buttonEnable
                  : context.appColors.colorDarkGray),
        ),
      );
    }

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(title),
        actions: options.map(buildAction).toList(),
      ),
    );
  }

  Widget tfSearch(BuildContext context) => TextFormField(
        style: context.textTheme.bodySmall,
        onChanged: onSearch,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: context.l10n.text_hint_search,
          hintStyle: TextStyle(color: context.appColors.colorDarkGray),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade600,
            size: 20,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.all(8),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.shade100)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.shade100)),
        ),
      );

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
