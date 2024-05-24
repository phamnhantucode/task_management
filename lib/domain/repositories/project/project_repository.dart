import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/domain/project/project.dart';
import '../../../models/dtos/project/project.dart';
import '../../../models/dtos/user/user_dto.dart';
import '../users/users_repository.dart';

class ProjectRepository {
  static final ProjectRepository instance = ProjectRepository();

  final CollectionReference _projectCollection =
      FirebaseFirestore.instance.collection('projects');

  Future<void> addProject(ProjectDto project) =>
      _projectCollection.doc(project.id).set(project.toJson());

  Future<void> updateProject(ProjectDto project) =>
      _projectCollection.doc(project.id).update(project.toJson());

  Future<void> deleteProject(String projectId) =>
      _projectCollection.doc(projectId).delete();

  Future<List<Project>> getProjects(String userId) async {
    final snapshot =
        await _projectCollection.where('ownerId', isEqualTo: userId).get();
    var projects = await Future.wait(snapshot.docs.map((doc) async {
      var projectDto = ProjectDto.fromJson(doc.data() as Map<String, dynamic>);
      var owner =
          await UsersRepository.instance.getUserById(projectDto.ownerId);
      if (owner == null) throw Exception('Owner not found');
      var members = (await Future.wait(projectDto.membersId
              .map((id) => UsersRepository.instance.getUserById(id))))
          .whereType<UserDto>()
          .toList();
      return Project.fromProjectDto(projectDto, owner, members);
    }).toList());

    final memberProjects = await _projectCollection
        .where('membersId', arrayContains: userId)
        .get();

    projects.addAll(await Future.wait(memberProjects.docs.map((doc) async {
      var projectDto = ProjectDto.fromJson(doc.data() as Map<String, dynamic>);
      var owner =
          await UsersRepository.instance.getUserById(projectDto.ownerId);
      if (owner == null) throw Exception('Owner not found');
      var members = (await Future.wait(projectDto.membersId
              .map((id) => UsersRepository.instance.getUserById(id))))
          .whereType<UserDto>()
          .toList();
      return Project.fromProjectDto(projectDto, owner, members);
    }).toList()));

    return projects;
  }

  Stream<List<Project>> getProjectsStream(String userId) {
    return _projectCollection
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .asyncMap(
      (snapshot) async {
        var projects = await Future.wait(snapshot.docs.map((doc) async {
          var projectDto =
              ProjectDto.fromJson(doc.data() as Map<String, dynamic>);
          var owner =
              await UsersRepository.instance.getUserById(projectDto.ownerId);
          if (owner == null) throw Exception('Owner not found');
          var members = (await Future.wait(projectDto.membersId
                  .map((id) => UsersRepository.instance.getUserById(id))))
              .whereType<UserDto>()
              .toList();

          return Project.fromProjectDto(projectDto, owner, members);
        }).toList());

        var memberProjects = await _projectCollection
            .where('membersId', arrayContains: userId)
            .get();

        projects.addAll(await Future.wait(memberProjects.docs.map((doc) async {
          var projectDto =
              ProjectDto.fromJson(doc.data() as Map<String, dynamic>);
          var owner =
              await UsersRepository.instance.getUserById(projectDto.ownerId);
          if (owner == null) throw Exception('Owner not found');
          var members = (await Future.wait(projectDto.membersId
                  .map((id) => UsersRepository.instance.getUserById(id))))
              .whereType<UserDto>()
              .toList();
          return Project.fromProjectDto(projectDto, owner, members);
        }).toList()));

        return projects;
      },
    );
  }

  Future<Project> getProject(String projectId) async {
    final snapshot = await _projectCollection.doc(projectId).get();
    var projectDto =
        ProjectDto.fromJson(snapshot.data() as Map<String, dynamic>);
    var owner = await UsersRepository.instance.getUserById(projectDto.ownerId);
    if (owner == null) throw Exception('Owner not found');
    var members = (await Future.wait(projectDto.membersId
            .map((id) => UsersRepository.instance.getUserById(id))))
        .whereType<UserDto>()
        .toList();
    return Project.fromProjectDto(projectDto, owner, members);
  }

  Stream<Project> getProjectStream(String projectId) {
    return _projectCollection.doc(projectId).snapshots().asyncMap(
      (snapshot) async {
        var data = snapshot.data();
        if (data == null) {
          throw Exception('Project not found');
        }
        var projectDto = ProjectDto.fromJson(data as Map<String, dynamic>);
        var owner =
            await UsersRepository.instance.getUserById(projectDto.ownerId);
        if (owner == null) throw Exception('Owner not found');
        var members = (await Future.wait(projectDto.membersId
                .map((id) => UsersRepository.instance.getUserById(id))))
            .whereType<UserDto>()
            .toList();
        return Project.fromProjectDto(projectDto, owner, members);
      },
    );
  }

  // CRUD for Attachments in Project
  Future<void> addAttachmentToProject(
      String projectId, AttachmentDto attachment) {
    return _projectCollection
        .doc(projectId)
        .collection('attachments')
        .doc(attachment.id)
        .set(attachment.toJson());
  }

  Stream<List<Attachment>> getAttachmentsFromProjectStream(String projectId) {
    return _projectCollection
        .doc(projectId)
        .collection('attachments')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Attachment.fromAttachmentDto(
                AttachmentDto.fromJson(doc.data())))
            .toList());
  }

  Future<void> updateAttachmentInProject(
      String projectId, AttachmentDto attachment) {
    return _projectCollection
        .doc(projectId)
        .collection('attachments')
        .doc(attachment.id)
        .update(attachment.toJson());
  }

  Future<void> deleteAttachmentFromProject(
      String projectId, String attachmentId) {
    return _projectCollection
        .doc(projectId)
        .collection('attachments')
        .doc(attachmentId)
        .delete();
  }

  // CRUD for Tasks in Project
  Future<void> addTaskToProject(String projectId, TaskDto task) {
    return _projectCollection
        .doc(projectId)
        .collection('tasks')
        .doc(task.id)
        .set(task.toJson());
  }

  Stream<List<Task>> getTasksFromProjectStream(String projectId) {
    return _projectCollection
        .doc(projectId)
        .collection('tasks')
        .snapshots()
        .asyncMap((snapshot) async {
      return await Future.wait(snapshot.docs.map((doc) async {
        final taskDto = TaskDto.fromJson(doc.data());
        final assignees = await Future.wait(taskDto.assigneeIds
            .map((id) => UsersRepository.instance.getUserById(id)));

        final author =
            await UsersRepository.instance.getUserById(taskDto.authorId);
        if (author == null) throw Exception('Author not found');
        final project = await getProject(taskDto.projectId);
        return Task.fromTaskDto(taskDto, project, assignees, author);
      }).toList());
    });
  }

  Future<void> updateTaskInProject(String projectId, TaskDto task) {
    return _projectCollection
        .doc(projectId)
        .collection('tasks')
        .doc(task.id)
        .update(task.toJson());
  }

  Future<void> deleteTaskFromProject(String projectId, String taskId) {
    return _projectCollection
        .doc(projectId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  // CRUD for Attachments in Task
  Future<void> addAttachmentToTask(
      String projectId, String taskId, AttachmentDto attachment) {
    return _projectCollection
        .doc(projectId)
        .collection('tasks')
        .doc(taskId)
        .collection('attachments')
        .doc(attachment.id)
        .set(attachment.toJson());
  }

  Stream<List<Attachment>> getAttachmentsFromTaskStream(
      String projectId, String taskId) {
    return _projectCollection
        .doc(projectId)
        .collection('tasks')
        .doc(taskId)
        .collection('attachments')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Attachment.fromAttachmentDto(
                AttachmentDto.fromJson(doc.data())))
            .toList());
  }

  Future<void> updateAttachmentInTask(
      String projectId, String taskId, AttachmentDto attachment) {
    return _projectCollection
        .doc(projectId)
        .collection('tasks')
        .doc(taskId)
        .collection('attachments')
        .doc(attachment.id)
        .update(attachment.toJson());
  }

  Future<void> deleteAttachmentFromTask(
      String projectId, String taskId, String attachmentId) {
    return _projectCollection
        .doc(projectId)
        .collection('tasks')
        .doc(taskId)
        .collection('attachments')
        .doc(attachmentId)
        .delete();
  }

  Stream<List<UserDto>> getProjectMembers(String projectId) {
    return _projectCollection
        .doc(projectId)
        .snapshots()
        .asyncMap((snapshot) => _getProjectMembers(snapshot));
  }

  Future<List<UserDto>> _getProjectMembers(DocumentSnapshot snapshot) async {
    final project =
        ProjectDto.fromJson(snapshot.data() as Map<String, dynamic>);
    final membersId = project.membersId;

    final usersRepository = UsersRepository.instance;
    final members = <UserDto>[];
    for (final memberId in membersId) {
      final member = await usersRepository.getUserById(memberId);
      if (member != null) {
        members.add(member);
      }
    }

    return members;
  }

  Future<void> addMemberToProject(String projectId, String memberId) {
    return _projectCollection.doc(projectId).update({
      'membersId': FieldValue.arrayUnion([memberId])
    });
  }

  Future<void> removeMemberFromProject(String projectId, String memberId) {
    return _projectCollection.doc(projectId).update({
      'membersId': FieldValue.arrayRemove([memberId])
    });
  }

  Future<Task?> getTaskDetail(String projectId, String taskId) async {
    final querySnapshot = await _projectCollection
        .doc(projectId)
        .collection('tasks')
        .doc(taskId)
        .get();
    if (querySnapshot != null) {
      TaskDto taskDto =
          TaskDto.fromJson(querySnapshot.data() as Map<String, dynamic>);

      final project = await getProject(taskDto.projectId);
      final author =
          await UsersRepository.instance.getUserById(taskDto.authorId);
      final assignees = await Future.wait(taskDto.assigneeIds
          .map((id) => UsersRepository.instance.getUserById(id)));
      if (author == null) throw Exception('Author not found');

      return Task.fromTaskDto(taskDto, project, assignees, author);
    } else {
      print("No task found with the given ID");
    }

    return null;
  }

  Future<List<Task>> getTasksAssignedToUser(String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collectionGroup('tasks')
        .where('assigneeId', isEqualTo: userId)
        .get();

    return Future.wait(querySnapshot.docs.map((doc) async {
      final taskDto = TaskDto.fromJson(doc.data());
      final assignees = await Future.wait(taskDto.assigneeIds
          .map((id) => UsersRepository.instance.getUserById(id)));
      final author =
          await UsersRepository.instance.getUserById(taskDto.authorId);
      if (author == null) throw Exception('Author not found');
      final project = await getProject(taskDto.projectId);

      return Task.fromTaskDto(
          TaskDto.fromJson(doc.data()), project, assignees, author);
    }).toList());
  }

  Stream<List<Task>> getTasksAssignedToUserStream(String userId) {
    return FirebaseFirestore.instance
        .collectionGroup('tasks')
        .where('assigneeIds', arrayContains: userId)
        .snapshots()
        .asyncMap((snapshot) async {
      return await Future.wait(snapshot.docs.map((doc) async {
        final taskDto = TaskDto.fromJson(doc.data());
        final assignees = await Future.wait(taskDto.assigneeIds
            .map((id) => UsersRepository.instance.getUserById(id)));
        final author =
            await UsersRepository.instance.getUserById(taskDto.authorId);
        if (author == null) throw Exception('Author not found');
        final project = await getProject(taskDto.projectId);
        return Task.fromTaskDto(taskDto, project, assignees, author);
      }).toList());
    });
  }

  Future<double> getProjectProgressFuture(String projectId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('projects')
        .doc(projectId)
        .collection('tasks')
        .get();

    final totalTasks = snapshot.docs.length;
    final completedTasks = snapshot.docs.where((doc) {
      final task = TaskDto.fromJson(doc.data());
      return task.status == TaskStatus.completed;
    }).length;

    if (totalTasks == 0) return 0.0;

    return completedTasks / totalTasks;
  }

  Future<double> getUserTaskProgressFuture(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collectionGroup('tasks')
        .where('assigneeId', isEqualTo: userId)
        .get();

    final totalTasks = snapshot.docs.length;
    final completedTasks = snapshot.docs.where((doc) {
      final task = TaskDto.fromJson(doc.data());
      return task.status == TaskStatus.completed;
    }).length;

    if (totalTasks == 0) return 0.0;

    return completedTasks / totalTasks;
  }

  Stream<double> getProjectProgress(String projectId) {
    return FirebaseFirestore.instance
        .collection('projects')
        .doc(projectId)
        .collection('tasks')
        .snapshots()
        .map((snapshot) {
      final totalTasks = snapshot.docs.length;
      final completedTasks = snapshot.docs.where((doc) {
        final task = TaskDto.fromJson(doc.data());
        return task.status == TaskStatus.completed;
      }).length;

      if (totalTasks == 0) return 0.0;

      return completedTasks / totalTasks;
    });
  }

  Stream<double> getUserTaskProgress(String userId) {
    return FirebaseFirestore.instance
        .collectionGroup('tasks')
        .where('assigneeId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final totalTasks = snapshot.docs.length;
      final completedTasks = snapshot.docs.where((doc) {
        final task = TaskDto.fromJson(doc.data());
        return task.status == TaskStatus.completed;
      }).length;

      if (totalTasks == 0) return 0.0;

      return completedTasks / totalTasks;
    });
  }

  void updateProjectColor(String id, Color color) {
    _projectCollection.doc(id).update({'color': color.value});
  }

  Future<void> addProjectNote(String id, NotesDto notesDto) async {
    return _projectCollection
        .doc(id)
        .collection('notes')
        .doc(notesDto.id)
        .set(notesDto.toJson());
  }

  //getAllNote return Stream List<Notes>
  Stream<List<Notes>> getAllNotes(String projectId) {
    return _projectCollection
        .doc(projectId)
        .collection('notes')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Notes.fromNotesDto(NotesDto.fromJson(doc.data())))
            .toList());
  }

  void removeMember(String projectId, String userId) {
    _projectCollection.doc(projectId).update({
      'membersId': FieldValue.arrayRemove([userId])
    });
  }

  void updateProjectDueDate(String id, DateTime e) {
    _projectCollection.doc(id).update({'endDate': e.toString()});
  }

  void leaveProject(String id, String? uid) {
    if (uid != null) {
      _projectCollection.doc(id).update({
        'membersId': FieldValue.arrayRemove([uid])
      });
    }
  }

  void addTaskAssignees(String taskId, String projectId, List<String> newAssignees) {
    _projectCollection.doc(projectId).collection('tasks').doc(taskId).update({
      'assigneeIds': FieldValue.arrayUnion(newAssignees)
    });
  }
}
