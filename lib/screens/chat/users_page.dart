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
      width: 60,
      height: 60,
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
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.only(
                      topEnd: Radius.circular(25),
                      topStart: Radius.circular(25),
                    ),
                  ),
                  builder: (context) => Container(
                    padding: const EdgeInsetsDirectional.only(
                      start: 10,
                      end: 10,
                      bottom: 30,
                      top: 15,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 600,
                          child: PageView(
                            children: <Widget>[
                              SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                    2,
                                    (index) => Container(
                                      height: 75,
                                      margin: const EdgeInsetsDirectional.only(
                                          bottom: 10),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color:
                                            context.appColors.bgGrayWhiteLight,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 8,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      'https://mcdn.coolmate.me/image/March2023/meme-meo-2.jpg'),
                                                  maxRadius: 30,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,top: 8),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text("Nguyen Anh Quan",
                                                          style: context
                                                              .textTheme
                                                              .bodyMedium
                                                              ?.copyWith(
                                                                  color: context
                                                                      .appColors
                                                                      .textBlack)),
                                                      const SizedBox(
                                                        height: 2,
                                                      ),
                                                      Text("10 friends",
                                                          style: context
                                                              .textTheme
                                                              .bodySmall
                                                              ?.copyWith(
                                                                  color: context
                                                                      .appColors
                                                                      .colorDarkGray)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                TextButton(
                                                    onPressed: null,
                                                    style: TextButton.styleFrom(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                                horizontal: 12),
                                                        minimumSize:
                                                            const Size(50, 24),
                                                        backgroundColor:
                                                            Colors.blue,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    6)),
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        alignment: Alignment
                                                            .centerLeft),
                                                    child: Text(context.l10n.accept,
                                                        style: context
                                                            .textTheme.bodySmall
                                                            ?.copyWith(
                                                                color: context.appColors.textWhite))),
                                                TextButton(
                                                  onPressed: null,
                                                  child: Text(
                                                      context.l10n.decline,
                                                      style: context
                                                          .textTheme.bodySmall
                                                          ?.copyWith(
                                                              color: context
                                                                  .appColors
                                                                  .colorDarkGray)),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder<List<types.User?>>(
          future: FriendRepository.instance
              .getAcceptedFriends(
                  context.read<AuthenticationCubit>().state.user?.uid ?? '')
              .then((value) {
            return value
                .map((e) async {
                  if (context.read<AuthenticationCubit>().state.user?.uid ==
                      e.authorId) {
                    return UsersRepository.instance.getUserById(e.targetId);
                  } else {
                    return UsersRepository.instance.getUserById(e.authorId);
                  }
                })
                .toList()
                .wait;
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
                    child: Column(
                      children: [
                        TFSearch(context),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              _buildAvatar(user),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user.firstName ?? '',
                                      style: context.textTheme.labelSmall
                                          ?.copyWith(
                                              color:
                                                  context.appColors.textBlack)),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text("Management",
                                      style: context.textTheme.bodySmall
                                          ?.copyWith(
                                              color: context
                                                  .appColors.colorDarkGray)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          },
        ),
      );
}
Widget TFSearch(BuildContext context)=> Padding(
    padding: const EdgeInsets.only(
        top: 16, left: 16, right: 16, bottom: 16),
    child: TextFormField(
      style: context.textTheme.bodySmall,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Search...",
        hintStyle: TextStyle(
            color: context.appColors.colorDarkGray),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.grey.shade600,
          size: 20,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: EdgeInsets.all(8),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide:
            BorderSide(color: Colors.grey.shade100)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide:
            BorderSide(color: Colors.grey.shade100)),
      ),
    ),
  );