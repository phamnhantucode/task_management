enum ActionNotification {
  inviteToProject,
  acceptRequestToProject,
  assignInTask,
  addNote,
  submitTask,
  changeStatusTask,
  changeStatusProject,
  changeStatusRequest,
  removeFromProject,
  removeTask,
  changeDueDateTask,
  changeDueDateProject, changeProjectName;

  static ActionNotification fromString(String value) {
    switch (value) {
      case 'inviteToProject':
        return ActionNotification.inviteToProject;
      case 'acceptRequestToProject':
        return ActionNotification.acceptRequestToProject;
      case 'assignInTask':
        return ActionNotification.assignInTask;
      case 'addNote':
        return ActionNotification.addNote;
      case 'submitTask':
        return ActionNotification.submitTask;
      case 'changeStatusTask':
        return ActionNotification.changeStatusTask;
      case 'changeStatusProject':
        return ActionNotification.changeStatusProject;
      case 'changeStatusRequest':
        return ActionNotification.changeStatusRequest;
      case 'removeFromProject':
        return ActionNotification.removeFromProject;
      case 'removeTask':
        return ActionNotification.removeTask;
      case 'changeDueDateTask':
        return ActionNotification.changeDueDateTask;
      case 'changeDueDateProject':
        return ActionNotification.changeDueDateProject;
      default:
        throw Exception('Invalid value');
    }
  }
}

enum TargetType {
  project,
  user,
  task,
  comment,
}