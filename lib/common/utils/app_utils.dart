import '../../models/domain/project/project.dart';

bool isOwnerProject(String userId, Project project) {
  return userId == project.owner.id;
}