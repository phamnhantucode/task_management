import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:room_master_app/blocs/authentication/authentication_cubit.dart';
import 'package:room_master_app/domain/repositories/friends/friends_repository.dart';
import 'package:room_master_app/domain/repositories/users/users_repository.dart';
import 'package:room_master_app/l10n/l10n.dart';

import '../../common/extensions/extensions.dart';
import '../../common/utils/utils.dart';
import 'chat_page.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  Widget _buildAvatar(types.User user) {
    final color = getUserAvatarNameColor(user);
    final hasImage = user.imageUrl != null;
    final name = user.firstName ?? '';

    return Container(
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

  void _handlePressed(types.User otherUser, BuildContext context) async {
    final navigator = Navigator.of(context);
    final room = await FirebaseChatCore.instance.createRoom(otherUser);

    navigator.pop();
    await navigator.push(
      MaterialPageRoute(
        builder: (context) => ChatPage(
          room: room,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: Text(context.l10n.text_friend),
        ),
        body: FutureBuilder<List<types.User?>>(
          future: FriendRepository.instance.getAcceptedFriends(context.read<AuthenticationCubit>().state.user?.uid ?? '').then((value) {
            return value.map((e) async {
              if (context.read<AuthenticationCubit>().state.user?.uid == e.authorId) {
                return UsersRepository.instance.getUserById(e.targetId);
              } else {
                return UsersRepository.instance.getUserById(e.authorId);
              }
            }).toList().wait;
          }),
          initialData: const [],
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                  bottom: 200,
                ),
                child: Text(context.l10n.text_no_users),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                if (user == null) {
                  return Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(
                      bottom: 200,
                    ),
                    child: Text(context.l10n.text_no_users),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                        _handlePressed(user, context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          _buildAvatar(user),
                          Text(user.firstName ?? ''),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          },
        ),
      );
}