import 'dart:developer';

import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/common/assets/app_assets.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/common/extensions/date_time.dart';
import 'package:room_master_app/common/utils/utils.dart';
import 'package:room_master_app/domain/repositories/project/project_repository.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/navigation/navigation.dart';
import 'package:room_master_app/screens/component/SpacerComponent.dart';
import 'package:room_master_app/screens/component/task_container.dart';
import 'package:room_master_app/screens/component/top_header/primary.dart';
import 'package:room_master_app/screens/qr_scanner/qr_scanner_screen.dart';

import '../../blocs/authentication/authentication_cubit.dart';
import '../../models/domain/project/project.dart';
import '../../models/dtos/project/project.dart';
import 'bloc/home_screen_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeScreenBloc()..add(const HomeScreenEvent.initBloc()),
      child: Builder(builder: (context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildTopHeader(context),
              SpacerComponent.l(),
              _buildBanner(context),
              SpacerComponent.l(),
              _buildProjects(context),
              SpacerComponent.l(),
              Container(
                padding: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(
                          width: 1, color: context.appColors.borderColor)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.l10n.today_task,
                      style: const TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(context.l10n.seeall,
                        style: context.textTheme.bodyMedium),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(
                            width: 1,
                            color: context.appColors.borderColor)),
                    boxShadow: [
                      BoxShadow(
                        color: context.appColors.borderColor,
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 3), // Moves shadow to the top
                      ),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  height: 400, // fixed height
                  child: _buildTodayTask(),
                ),
              ),
              SpacerComponent.l(),
            ],
          ),
        );
      }),
    );
  }

  Widget buildMembers(List<types.User> members) {
    final settings = RestrictedAmountPositions(
        maxAmountItems: 5,
        maxCoverage: 0.3,
        minCoverage: 0.2,
        align: StackAlign.right);
    return AvatarStack(settings: settings, height: 20, borderWidth: 0,avatars: [
      for (var n = 0; n < members.length; n++)
        CachedNetworkImageProvider(members[n].imageUrl ?? getAvatarUrl(n)),
    ]);
  }

  String getAvatarUrl(int n) {
    final url = 'https://robohash.org/$n?bgset=bg1';
    return url;
  }

  Widget _buildTopHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TopHeader(
          title: context.l10n.header_home,
          rightIcon: Icons.qr_code,
          leftAction: () {
            context.read<AuthenticationCubit>().logout();
          },
          rightAction: () => {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const QrScannerScreen(),
                ))
              }),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: context.appColors.bgGrayLight,
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              context.appColors.buttonEnable,
              Colors.lightBlueAccent,
            ],
          )),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.header_home,
                style: context.textTheme.titleSmall
                    ?.copyWith(color: context.appColors.textWhite),
              ),
              const Text(
                "15 task",
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(child: SizedBox()),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.l10n.progress,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            const Text(
                              '40%',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: 200,
                        child: LinearProgressIndicator(
                          value: 0.4,
                          minHeight: 8,
                          color: Colors.white,
                          backgroundColor: context.appColors.bgGrayLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      )
                    ],
                  )
                ],
              )
            ]),
      ),
    );
  }

  Widget _buildProjects(BuildContext context) {
    return BlocBuilder<HomeScreenBloc, HomeScreenState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                context.l10n.text_your_project,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                disableCenter: true,
                viewportFraction: 0.88,
                enlargeCenterPage: false,
                height: 210,
              ),
              items: state.projects
                  .map((item) {
                    final bgColor = Colors.blue.shade100;
                    final color = getContrastColor(bgColor);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      context.push(NavigationPath.detailProject,
                          extra: item.id);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      decoration: BoxDecoration(
                          color: bgColor,
                          image: const DecorationImage(
                              image: AssetImage(AppAssets.imageBgContainer),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                color: context.appColors.borderColor,
                                offset: const Offset(0, 1),
                                spreadRadius: 0.5,
                                blurRadius: 2)
                          ]),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.name,
                                  style: context.textTheme.labelMedium?.copyWith(color: color),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    print('Share qr');
                                  },
                                  child: const Icon(
                                    Icons.share,
                                    size: 18,
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time_filled,
                                        size: 16,
                                        color: color,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        item.endDate?.dateWeeksMonthFormat ?? context.l10n.text_empty,
                                        style: context.textTheme.bodySmall?.copyWith(color: color),
                                      ),
                                    ],
                                  ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 16,
                                      color: color,
                                    ),
                                    const SizedBox(width: 6),
                                    StreamBuilder<List<Task>>(
                                        stream: ProjectRepository.instance.getTasksFromProjectStream(item.id),
                                        builder: (context, snapshot) {
                                          if(snapshot.data != null) {
                                            return Text('${snapshot.data!.length.toString().padLeft(2, '0')} tasks',
                                              style: context.textTheme.bodyLarge?.copyWith(color: color),
                                            );
                                          } else {
                                            return const Text('00/00');
                                          }
                                        }
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      StreamBuilder<List<Task>>(
                                          stream: ProjectRepository.instance.getTasksFromProjectStream(item.id),
                                          builder: (context, snapshot) {
                                            if(snapshot.data != null) {
                                              return Text('${snapshot.data!.where((element) => element.status == TaskStatus.completed).length.toString().padLeft(2, '0')}/${snapshot.data!.length.toString().padLeft(2, '0')}',
                                                style: context.textTheme.bodySmall?.copyWith(color: color),
                                              );
                                            } else {
                                              return const Text('00/00');
                                            }
                                          }
                                      ),
                                      Expanded(child: buildMembers(item.members)),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: FutureBuilder<double>(
                                        future: ProjectRepository.instance.getProjectProgressFuture(item.id),
                                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                          return LinearProgressIndicator(
                                            value: snapshot.data ?? 0,
                                            minHeight: 5,
                                            color: color,
                                            backgroundColor: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(4),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      context.l10n.progress,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Expanded(
                                        child: FutureBuilder<double>(
                                          future: ProjectRepository.instance.getProjectProgressFuture(item.id),
                                          builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                                            return Text(context.l10n.text_percent_with_number(snapshot.data != null ? (snapshot.data! * 100).toStringAsFixed(0) : ''),
                                              textAlign: TextAlign.end,
                                              style: context.textTheme.labelSmall,
                                            );
                                          },
                                        ))
                                  ],
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ),
                );
              })
                  .toList(),
            )
          ],
        );
      },
    );
  }

  Widget _buildTodayTask() {
    return ListView.builder(
      itemBuilder: (context, index) => TaskContainer(
        context: context,
        isShadowContainer: false,
        title: 'Test Title',
        content: 'Test content',
        backgroundColor: Colors.blue.shade50,
        iconBackgroundColor: Colors.blue.shade100,
        contentColor: Colors.blue.shade500,
      ),
      itemCount: 20,
    );
  }
}
