import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/common/utils/utils.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/component/SpacerComponent.dart';
import 'package:room_master_app/screens/project_detail/project_detail_cubit.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:room_master_app/screens/task_detai_real/cubit/task_detail_cubit.dart';

class ModalListMember extends StatefulWidget {
  const ModalListMember(
      {super.key,
      required this.projectId,
      this.assignee,
      required this.onPressAdd,
      required this.taskId});
  final String projectId;
  final String taskId;
  final types.User? assignee;
  final Function onPressAdd;
  @override
  State<StatefulWidget> createState() => ModalListMemberState();
}

class ModalListMemberState extends State<ModalListMember> {
  final TextEditingController _searchController = TextEditingController();
  String searchMemberText = '';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ProjectDetailCubit()..init(widget.projectId),
          ),
          BlocProvider(
            create: (context) =>
                TaskDetailCubit()..init(widget.projectId, widget.taskId),
          )
        ],
        child: BlocBuilder<ProjectDetailCubit, ProjectDetailState>(
            builder: (s, state) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: SafeArea(
              child: Column(
                children: [
                  SpacerComponent.l(),
                  buildSearch(),
                  SpacerComponent.l(),
                  Expanded(child: buildInvitableList(s))
                ],
              ),
            ),
          );
        }));
  }

  buildSearch() {
    return SearchBar(
      controller: _searchController,
      padding: const MaterialStatePropertyAll<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 16.0)),
      onChanged: (text) {
        setState(() {
          searchMemberText = text;
        });
      },
      trailing: <Widget>[
        IconButton(onPressed: () {}, icon: const Icon(Icons.search))
      ],
    );
  }

  _buildAvatar(types.User user) {
    final color = getUserAvatarNameColor(user);
    final hasImage = user.imageUrl != null;
    final name = user.firstName ?? '';

    return Container(
      width: 48,
      height: 48,
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(user.imageUrl!) : null,
        radius: 20,
        child: !hasImage
            ? Text(
                name.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }

  buildInvitableList(BuildContext contextProjectDetail) {
    List<types.User> invitableUsers = contextProjectDetail
        .watch<ProjectDetailCubit>()
        .state
        .members
        .where((user) {
      String fullName = "${user.firstName} ${user.lastName}";
      return fullName.contains(searchMemberText);
    }).toList();
    if (invitableUsers.isEmpty) {
      return Center(
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(bottom: 200),
          child: Text(context.l10n.text_no_users),
        ),
      );
    }

    return ListView.builder(
      itemCount: invitableUsers.length,
      itemBuilder: (context, index) {
        final user = invitableUsers[index];
        bool isCurrentAdded = invitableUsers.firstWhereOrNull(
                (element) => element.id == widget.assignee?.id) !=
            null;
        return GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Row(
              children: [
                _buildAvatar(user),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.firstName ?? '',
                          style: context.textTheme.labelSmall
                              ?.copyWith(color: context.appColors.textBlack)),
                      const SizedBox(height: 2),
                      Text("Management",
                          style: context.textTheme.bodySmall?.copyWith(
                              color: context.appColors.colorDarkGray)),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      widget.onPressAdd(user, isCurrentAdded);
                    },
                    icon: Icon(isCurrentAdded
                        ? Icons.remove_circle_outline
                        : Icons.add_circle_outline))
              ],
            ),
          ),
        );
      },
    );
  }

  String getAvatarUrl(int n) {
    final url = 'https://robohash.org/$n?bgset=bg1';
    return url;
  }
}
