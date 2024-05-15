import 'package:badges/badges.dart' as badges;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:room_master_app/blocs/authentication/authentication_cubit.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/common/utils/utils.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/chat/chat_page.dart';
import 'package:room_master_app/screens/chat/users_page.dart';

import '../../domain/repositories/friends/friends_repository.dart';
import '../../models/domain/friend/friend.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  bool _error = false;
  bool _initialized = false;
  User? _user;

  @override
  void initState() {
    initializedFlutterFire();
    super.initState();
  }

  void initializedFlutterFire() async {
    try {
      FirebaseAuth.instance.authStateChanges().listen((user) {
        setState(() {
          _user = user;
        });
      });
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  void logout() {
    context.read<AuthenticationCubit>().logout();
  }

  Widget _buildAvatar(types.Room room) {
    var color = Colors.transparent;

    if (room.type == types.RoomType.direct) {
      try {
        final otherUser = room.users.firstWhere(
          (element) => element.id != _user!.uid,
        );

        color = getUserAvatarNameColor(otherUser);
      } catch (e) {
        //
      }
    }

    final hasImage = room.imageUrl != null;
    final name = room.name ?? '';

    return Container(
        width: 60,
        height: 60,
        margin: const EdgeInsets.only(right: 16),
        child: CircleAvatar(
            backgroundColor: hasImage ? Colors.transparent : color,
            backgroundImage: hasImage ? NetworkImage(room.imageUrl!) : null,
            radius: 20,
            child: !hasImage
                ? Text(
                    name.isEmpty ? '' : name[0].toUpperCase(),
                    style: context.textTheme.labelSmall
                        ?.copyWith(color: context.appColors.textWhite),
                  )
                : null));
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Container();
    }

    if (!_initialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          StreamBuilder<List<Friend>>(
              stream: FriendRepository.instance.getListWaitedAcceptedStream(
                  FirebaseAuth.instance.currentUser?.uid ?? ''),
              builder: (context, snapshot) {
                return badges.Badge(
                  badgeContent: const SizedBox(),
                  showBadge: snapshot.data?.isNotEmpty ?? false,
                  position: badges.BadgePosition.topEnd(top: 5, end: 5),
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _user == null
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => const UsersPage(),
                              ),
                            );
                          },
                  ),
                );
              }),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text('Rooms'),
      ),
      body: _user == null
          ? const SizedBox.shrink()
          : Column(
              children: [
                TFSearch(context),
                Expanded(
                  child: StreamBuilder<List<types.Room>>(
                    stream: FirebaseChatCore.instance.rooms(),
                    initialData: const [],
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                            bottom: 200,
                          ),
                          child: const Text('No rooms'),
                        );
                      }

                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final room = snapshot.data![index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    room: room,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  _buildAvatar(room),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(room.name ?? '',
                                          style: context.textTheme.labelSmall
                                              ?.copyWith(
                                                  color: context
                                                      .appColors.textBlack)),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      StreamBuilder<List<types.Message>>(
                                          stream: FirebaseChatCore.instance
                                              .messages(snapshot.data![index]),
                                          builder: (context, snapshot) {
                                            String lastMessage = '';
                                            if (snapshot.hasData) {
                                              switch (
                                                  snapshot.data!.first.type) {
                                                case types.MessageType.audio:
                                                case types.MessageType.custom:
                                                case types.MessageType.system:
                                                case types
                                                      .MessageType.unsupported:
                                                case types.MessageType.video:
                                                  if (snapshot.data!.first
                                                          .author.id ==
                                                      _user!.uid) {
                                                    lastMessage = context.l10n
                                                        .text_you_have_sent_a_message;
                                                  } else {
                                                    lastMessage = context.l10n
                                                        .text_someone_have_sent_a_message(
                                                            snapshot
                                                                    .data!
                                                                    .first
                                                                    .author
                                                                    .firstName ??
                                                                '');
                                                  }
                                                case types.MessageType.file:
                                                  if (snapshot.data!.first
                                                          .author.id ==
                                                      _user!.uid) {
                                                    lastMessage = context.l10n
                                                        .text_you_have_sent_a_file;
                                                  } else {
                                                    lastMessage = context.l10n
                                                        .text_someone_have_sent_a_file(
                                                            snapshot
                                                                    .data!
                                                                    .first
                                                                    .author
                                                                    .firstName ??
                                                                '');
                                                  }
                                                case types.MessageType.image:
                                                  if (snapshot.data!.first
                                                          .author.id ==
                                                      _user!.uid) {
                                                    lastMessage = context.l10n
                                                        .text_you_have_sent_an_image;
                                                  } else {
                                                    lastMessage = context.l10n
                                                        .text_someone_have_sent_an_image(
                                                            snapshot
                                                                    .data!
                                                                    .first
                                                                    .author
                                                                    .firstName ??
                                                                '');
                                                  }
                                                case types.MessageType.text:
                                                  if (snapshot.data!.first
                                                          .author.id ==
                                                      _user!.uid) {
                                                    lastMessage = (snapshot
                                                                .data!
                                                                .first as types
                                                            .TextMessage)
                                                        .text;
                                                  } else {
                                                    lastMessage =
                                                        '${snapshot.data?.first.author.firstName}: ${(snapshot.data!.first as types.TextMessage).text}';
                                                  }
                                              }
                                              return Text(lastMessage,
                                                  style: context
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                          color: context
                                                              .appColors
                                                              .colorDarkGray));
                                            } else {
                                              return Text(
                                                  "Start your conservation here",
                                                  style: context
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                          color: context
                                                              .appColors
                                                              .colorDarkGray));
                                            }
                                          })
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget TFSearch(BuildContext context) => Padding(
        padding:
            const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
        child: TextFormField(
          style: context.textTheme.bodySmall,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search...",
            hintStyle: TextStyle(color: context.appColors.colorDarkGray),
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
                borderSide: BorderSide(color: Colors.grey.shade100)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey.shade100)),
          ),
        ),
      );
}
