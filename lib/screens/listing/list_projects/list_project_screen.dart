import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_master_app/blocs/authentication/authentication_cubit.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/component/project_card.dart';
import 'package:room_master_app/screens/listing/list_projects/bloc/list_projects_cubit.dart';

class ListProjectScreen extends StatelessWidget {
  const ListProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListProjectsCubit()
        ..init(context.read<AuthenticationCubit>().state.user?.uid ?? ''),
      child: BlocBuilder<ListProjectsCubit, ListProjectsState>(
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: Text(context.l10n.text_projects),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                    },
                  ),
                ],
              ),
              body: CustomScrollView(slivers: [
                SliverPersistentHeader(
                  delegate: ListAction(
                    onSearch: (value) =>
                        context.read<ListProjectsCubit>().searchProject(value),
                    onSort: (value) =>
                        context.read<ListProjectsCubit>().sortProject(value),
                    onFilter: (value) =>
                        context.read<ListProjectsCubit>().filterProject(value),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final project = state.projectsCopy[index];
                      return ProjectCard(project: project);
                    },
                    childCount: state.projectsCopy.length,
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
  final void Function(ProjectSortBy value)? onSort;
  final void Function(ProjectFilterBy value)? onFilter;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(child: tfSearch(context)),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              buildModal<ProjectSortBy>(
                  context: context,
                  title: context.l10n.text_sort_by,
                  current: context.read<ListProjectsCubit>().state.shortBy,
                  options: ProjectSortBy.values,
                  getText: (value) => value.getLocalizationText(context),
                  onSelected: (value) => onSort?.call(value));
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              buildModal<ProjectFilterBy>(
                  context: context,
                  title: context.l10n.text_filter_by,
                  current: context.read<ListProjectsCubit>().state.filterBy,
                  options: ProjectFilterBy.values,
                  getText: (value) => value.getLocalizationText(context),
                  onSelected: (value) => onFilter?.call(value));
            },
          ),
        ],
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
