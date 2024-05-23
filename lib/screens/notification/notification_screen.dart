import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/blocs/authentication/authentication_cubit.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/models/domain/notification/notification.dart';
import 'package:room_master_app/models/dtos/notification/action.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../common/assets/app_assets.dart';
import '../component/empty_page.dart';
import 'bloc/notification_cubit.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  //add tab bar controller and init dispose it
  late TabController tabController;
  int index = 0;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this)..addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          index = tabController.index;
        });
      },);
    });


    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationCubit()
        ..init(context.read<AuthenticationCubit>().state.user?.uid ?? ''),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            elevation: 2,
            shadowColor: context.appColors.borderColor,
            title: Text(
              context.l10n.text_notification,
              style: context.textTheme.titleMedium,
            ),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                context.pop();
              },
            ),
            actions: [
              IconButton(
                  icon: SvgPicture.asset(AppAssets.iconDoubleCheck),
                  onPressed: () {})
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.shade200),
                  child: Align(
                    widthFactor: 1.0,
                    alignment: Alignment.center,
                    child: TabBar(
                      tabAlignment: TabAlignment.start,
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      isScrollable: true,
                      labelPadding: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      controller: tabController,
                      dividerColor: Colors.transparent,
                      indicatorPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: context.appColors.buttonEnable.withOpacity(0.5),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        Tab(
                          child: SizedBox(
                            width: 120,
                            child: Text(
                              'Unread',
                              style: context.textTheme.bodyMedium?.copyWith(
                                  color: index == 0 ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Tab(
                          child: SizedBox(
                            width: 120,
                            child: Text(
                              'Recent',
                              style: context.textTheme.bodyMedium?.copyWith(
                                  color: index == 1 ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(controller: tabController, children: [
                    BlocBuilder<NotificationCubit, NotificationState>(
                      builder: (context, state) {
                        if (state.notificationsUnRead.isEmpty) {
                          return const EmptyPage(object: 'notifications');
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          itemCount: state.notificationsUnRead.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                buildNotification(
                                    context, state.notificationsUnRead[index]),
                                state.notificationsUnRead.length != index + 1
                                    ? Divider(
                                        color: context.appColors.borderColor,
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    BlocBuilder<NotificationCubit, NotificationState>(
                      builder: (context, state) {
                        if (state.notifications.isEmpty) {
                          return const EmptyPage(object: 'notifications');
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.notifications.length,
                          itemBuilder: (context, index) {
                            return buildNotification(
                                context, state.notifications[index]);
                          },
                        );
                      },
                    ),
                  ]),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget buildNotification(BuildContext context, NotificationDm notification) {
    switch (notification.action) {
      case ActionNotification.inviteToProject:
      // TODO: Handle this case.
      case ActionNotification.acceptRequestToProject:
      // TODO: Handle this case.
      case ActionNotification.assignInTask:
      // TODO: Handle this case.
      case ActionNotification.addNote:
      // TODO: Handle this case.
      case ActionNotification.submitTask:
      // TODO: Handle this case.
      case ActionNotification.changeStatusTask:
      // TODO: Handle this case.
      case ActionNotification.changeStatusProject:
      // TODO: Handle this case.
      case ActionNotification.changeStatusRequest:
      // TODO: Handle this case.
      case ActionNotification.removeFromProject:
      // TODO: Handle this case.
      case ActionNotification.removeTask:
      // TODO: Handle this case.
      case ActionNotification.changeDueDateTask:
      // TODO: Handle this case.
      case ActionNotification.changeDueDateProject:
      // TODO: Handle this case.
      case ActionNotification.changeProjectName:
        return buildNotificationChangeProjectName(
            context, notification as NotifyChangeProjectNameDm);
    }
  }

  Widget buildNotificationChangeProjectName(
      BuildContext context, NotifyChangeProjectNameDm notification) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(notification.author.imageUrl ?? ''),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: notification.author.firstName,
                          style: context.textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        const WidgetSpan(child: SizedBox(width: 4)),
                        TextSpan(
                          text: context.l10n.text_change_project_name,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.appColors.textGray,
                          ),
                        ),
                        const WidgetSpan(child: SizedBox(width: 4)),
                        TextSpan(
                          text: notification.target.name,
                          style: context.textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        const WidgetSpan(child: SizedBox(width: 4)),
                        TextSpan(
                          text: context.l10n.text_to,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.appColors.textGray,
                          ),
                        ),
                        const WidgetSpan(child: SizedBox(width: 4)),
                        TextSpan(
                          text: notification.newProjectName,
                          style: context.textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      timeago.format(notification.createdAt),
                      style: context.textTheme.bodySmall
                          ?.copyWith(color: context.appColors.textGray),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Container(
                        width: 1,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        color: context.appColors.textGray,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AppAssets.iconFolder,
                            width: 14,
                            color: context.appColors.textGray,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              notification.target.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodySmall
                                  ?.copyWith(color: context.appColors.textGray),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
