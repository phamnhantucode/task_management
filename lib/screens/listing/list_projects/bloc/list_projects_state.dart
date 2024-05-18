part of 'list_projects_cubit.dart';

@freezed
class ListProjectsState with _$ListProjectsState {
  const factory ListProjectsState({
    @Default(false) bool isLoading,
    @Default([]) List<Project> projects,
    @Default([]) List<Project> projectsCopy,
    @Default('') String searchQuery,
    @Default(ProjectSortBy.endDate) ProjectSortBy shortBy,
    @Default(ProjectFilterBy.all) ProjectFilterBy filterBy,
  }) = _ListProjectState;
}

enum ProjectSortBy {
  name,
  startDate,
  endDate;

  String getLocalizationText(BuildContext context) {
    switch (this) {
      case ProjectSortBy.name:
        return context.l10n.text_name;
      case ProjectSortBy.startDate:
        return context.l10n.text_start_date;
      case ProjectSortBy.endDate:
        return context.l10n.text_end_date;
    }
  }
}

enum ProjectFilterBy {
  all,
  owner,
  member;

  String getLocalizationText(BuildContext context) {
    switch (this) {
      case ProjectFilterBy.all:
        return context.l10n.text_all;
      case ProjectFilterBy.owner:
        return context.l10n.text_owner;
      case ProjectFilterBy.member:
        return context.l10n.text_member;
    }
  }
}
