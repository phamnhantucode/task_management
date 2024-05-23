import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:room_master_app/blocs/authentication/authentication_cubit.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/component/empty_page.dart';

import '../../common/extensions/extensions.dart';
import '../../common/utils/utils.dart';
import '../../models/dtos/user/user_dto.dart';
import 'bloc/user_friends_cubit.dart';
import 'chat_page.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({
    super.key,
  });

  Widget _buildAvatar(UserDto user) {
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

  void _handlePressed(UserDto otherUser, BuildContext context) async {
    final navigator = Navigator.of(context);
    final room =
        await FirebaseChatCore.instance.createRoom(UserDto.toUser(otherUser));
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
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => UserFriendsCubit()..init(),
        child: Builder(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle.light,
              title: Text(context.l10n.text_friend),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: badges.Badge(
                    position: badges.BadgePosition.topEnd(top: 0, end: 0),
                    showBadge: context
                        .watch<UserFriendsCubit>()
                        .state
                        .userWaitingAccepts
                        .isNotEmpty,
                    badgeContent: Text(
                      context
                          .watch<UserFriendsCubit>()
                          .state
                          .userWaitingAccepts
                          .length
                          .toString(),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.person_add,
                        size: 30,
                      ),
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
                          builder: (innerContext) => BlocProvider.value(
                            value: context.read<UserFriendsCubit>(),
                            child: buildUsersWaitingAcceptBottomSheet(
                                innerContext,
                                context
                                    .watch<UserFriendsCubit>()
                                    .state
                                    .userWaitingAccepts
                                    .map((e) => e.author)
                                    .toList(), (userAccept) {
                              context.read<UserFriendsCubit>().acceptFriend(
                                  context
                                      .watch<UserFriendsCubit>()
                                      .state
                                      .userWaitingAccepts
                                      .firstWhere((element) =>
                                          element.author.id == userAccept.id));
                            }, (userDecline) {
                              context.read<UserFriendsCubit>().declineFriend(
                                  context
                                      .watch<UserFriendsCubit>()
                                      .state
                                      .userWaitingAccepts
                                      .firstWhere((element) =>
                                          element.author.id == userDecline.id));
                            }),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                _buildSearchField(context),
                Expanded(child: _buildUserList(context)),
              ],
            ),
          );
        }),
      );

  Widget _buildSearchField(BuildContext context) => Padding(
        padding:
            const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
        child: TextFormField(
          style: context.textTheme.bodySmall,
          onChanged: (value) {
            context.read<UserFriendsCubit>().searchFriends(value);
          },
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

  Widget _buildUserList(BuildContext context) {
    return BlocBuilder<UserFriendsCubit, UserFriendsState>(
      builder: (context, state) {
        if (state.usersFiltered.isEmpty) {
          return Center(
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 200),
              child: Text(context.l10n.text_no_users),
            ),
          );
        }

        return ListView.builder(
          itemCount: state.usersFiltered.length,
          itemBuilder: (context, index) {
            final user = state.usersFiltered[index];
            return GestureDetector(
              onTap: () {
                _handlePressed(user, context);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: Row(
                  children: [
                    _buildAvatar(user),
                    Column(
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
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

Widget TFSearch(BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
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

Widget buildUsersWaitingAcceptBottomSheet(
    BuildContext context, List<UserDto> userWaitingAccepts,
    [void Function(UserDto)? accept, void Function(UserDto)? decline]) {
  return Container(
    padding: const EdgeInsetsDirectional.only(
      start: 10,
      end: 10,
      bottom: 30,
      top: 15,
    ),
    height: 500,
    child: Builder(
      builder: (BuildContext context) {
        if (userWaitingAccepts.isEmpty) {
          return const EmptyPage(object: 'requests', );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
                userWaitingAccepts.length,
                (index) => Container(
                      height: 75,
                      margin: const EdgeInsetsDirectional.only(
                          bottom: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: context.appColors.bgGrayWhiteLight,
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
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      userWaitingAccepts[index]
                                              .imageUrl ??
                                          ''),
                                  maxRadius: 30,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, top: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          userWaitingAccepts[index]
                                                  .firstName ??
                                              '',
                                          style: context
                                              .textTheme.bodyMedium
                                              ?.copyWith(
                                                  color: context
                                                      .appColors
                                                      .textBlack)),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      FutureBuilder(
                                        future: context
                                            .read<UserFriendsCubit>()
                                            .getNumberOfMutualFriends(
                                                context
                                                        .read<
                                                            AuthenticationCubit>()
                                                        .state
                                                        .user
                                                        ?.uid ??
                                                    '',
                                                userWaitingAccepts[
                                                            index]
                                                        .id ??
                                                    ''),
                                        builder: (context, snapshot) {
                                          final text = snapshot
                                                  .hasData
                                              ? '${snapshot.data} mutual friends'
                                              : 'You may be know';
                                          return Text(
                                            text,
                                            style: context
                                                .textTheme.bodySmall
                                                ?.copyWith(
                                                    color: context
                                                        .appColors
                                                        .colorDarkGray),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      accept?.call(
                                          userWaitingAccepts[index]);
                                    },
                                    style: TextButton.styleFrom(
                                        padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12),
                                        minimumSize:
                                            const Size(50, 24),
                                        backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                                    6)),
                                        tapTargetSize:
                                            MaterialTapTargetSize
                                                .shrinkWrap,
                                        alignment:
                                            Alignment.centerLeft),
                                    child: Text(context.l10n.accept,
                                        style: context
                                            .textTheme.bodySmall
                                            ?.copyWith(
                                                color: context
                                                    .appColors
                                                    .textWhite))),
                                TextButton(
                                  onPressed: () {
                                    decline?.call(
                                        userWaitingAccepts[index]);
                                  },
                                  child: Text(context.l10n.decline,
                                      style: context
                                          .textTheme.bodySmall
                                          ?.copyWith(
                                              color: context.appColors
                                                  .colorDarkGray)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
          );
        }
      },
    ),
  );
}
