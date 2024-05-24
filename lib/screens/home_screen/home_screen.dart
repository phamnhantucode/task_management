import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/common/assets/app_assets.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/navigation/navigation.dart';
import 'package:room_master_app/screens/component/SpacerComponent.dart';
import 'package:room_master_app/screens/component/empty_page.dart';
import 'package:room_master_app/screens/component/project_card.dart';
import 'package:room_master_app/screens/component/task_container.dart';
import 'package:room_master_app/screens/component/tm_elevated_button.dart';
import 'package:room_master_app/screens/qr_scanner/qr_scanner_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../blocs/authentication/authentication_cubit.dart';
import 'bloc/home_screen_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeScreenCubit()..init(),
      child: Builder(builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: context.mediaQuery.viewPadding.top + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildTopBar(context),
              SpacerComponent.l(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildBanner(context),
                      SpacerComponent.l(),
                      _buildProjects(context),
                      SpacerComponent.l(),
                      Container(
                        padding:
                        const EdgeInsets.only(bottom: 10, left: 12, right: 12),
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
                            GestureDetector(
                              onTap: () {
                                context.push(NavigationPath.listTasks);
                              },
                              child: Text(
                                context.l10n.seeall,
                                style: context.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        color: Colors.grey.shade100,
                        height: 400, // fixed height
                        child: _buildTodayTask(),
                      ),
                      SpacerComponent.l(),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  String getAvatarUrl(int n) {
    final url = 'https://robohash.org/$n?bgset=bg1';
    return url;
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 54,
                  height: 54,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      context
                              .watch<AuthenticationCubit>()
                              .state
                              .user
                              ?.photoURL ??
                          '',
                    ),
                  ),
                ),
                SpacerComponent.s(
                  isVertical: false,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Hello'),
                    Text(
                        context
                                .watch<AuthenticationCubit>()
                                .state
                                .user
                                ?.displayName ??
                            '',
                        style: context.textTheme.labelLarge),
                  ],
                )
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const QrScannerScreen()));
                  },
                  icon: const Icon(Icons.qr_code),
                ),
                IconButton(
                  onPressed: () {
                    context.push(NavigationPath.notification);
                  },
                  icon: const Icon(Icons.notifications_outlined),
                ),
              ],
            )
          ],
        ));
  }

  Widget _buildBanner(BuildContext context) {
    return const StatisticHomeScreen();
  }

  Widget _buildProjects(BuildContext context) {
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.text_your_project,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                  GestureDetector(
                    onTap: () => context.push(NavigationPath.listProjects),
                    child: Text(
                      context.l10n.seeall,
                      style: context.textTheme.bodyMedium
                          ?.copyWith(color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
            state.projects.isEmpty
                ? const EmptyPage2(
                    object: 'projects',
                  )
                : CarouselSlider(
                    options: CarouselOptions(
                      disableCenter: true,
                      viewportFraction: 0.88,
                      enlargeCenterPage: false,
                      height: 210,
                    ),
                    items: state.projects.map((item) {
                      return ProjectCard(project: item);
                    }).toList(),
                  )
          ],
        );
      },
    );
  }

  Widget _buildTodayTask() {
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
      builder: (context, state) {
        if (state.todayTasks.isEmpty) {
          return const EmptyPage(object: 'tasks',);
        }
        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: TaskContainer2(task: state.todayTasks[index]),
          ),
          itemCount: state.todayTasks.length,
        );
      },
    );
  }
}

class StatisticHomeScreen extends StatefulWidget {
  const StatisticHomeScreen({super.key});

  @override
  State<StatisticHomeScreen> createState() => _StatisticHomeScreenState();
}

class _StatisticHomeScreenState extends State<StatisticHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tooltip = TooltipBehavior(
        enable: true, format: 'point.x : point.y', duration: 500);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              dividerColor: Colors.transparent,
              labelPadding: const EdgeInsets.symmetric(horizontal: 20),
              controller: _tabController,
              tabs: const [
                Tab(
                  text: 'Today',
                ),
                Tab(
                  text: 'Next',
                ),
                Tab(
                  text: 'All',
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 175,
          child: TabBarView(
            controller: _tabController,
            children: [
              buildPieChart(context, 0),
              buildPieChart(context, 1),
              buildPieChart(context, 2),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPieChart(BuildContext context, int index) {
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
      builder: (context, state) {
        var numbersOfTask = '';
        var textDescription = '';
        var data = <TaskPieChartData>[];
        if (index == 0) {
          numbersOfTask =
              context.l10n.text_number_tasks(state.todayTasks.length);
          data = state.todayTasksPieChartData;
          textDescription =
              'Today, you have ${state.todayTasks.length} tasks to work on.';
          if (state.todayTasks.isEmpty) {
            textDescription = 'Today, you have no tasks to work on.';
          }
        } else if (index == 1) {
          numbersOfTask =
              context.l10n.text_number_tasks(state.nextTasks.length);
          data = state.nextTasksPieChartData;
          textDescription =
              'Next, you have ${state.nextTasks.length} tasks to work on.';
          if (state.nextTasks.isEmpty) {
            textDescription = 'Next, you have no tasks to work on.';
          }
        } else {
          numbersOfTask = context.l10n.text_number_tasks(state.allTasks.length);
          data = state.allTasksPieChartData;
          textDescription =
              'You have ${state.allTasks.length} tasks to work on for all.';
          if (state.allTasks.isEmpty) {
            textDescription = 'You have no tasks to work on for all.';
          }
        }
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              data.isNotEmpty
                  ? SizedBox(
                      width: 175,
                      child: SfCircularChart(
                        margin: EdgeInsets.zero,
                        annotations: [
                          CircularChartAnnotation(
                              widget: Text(numbersOfTask,
                                  style: context.textTheme.bodyMedium))
                        ],
                        series: <CircularSeries>[
                          DoughnutSeries<TaskPieChartData, String>(
                            strokeWidth: 2,
                            dataSource: data,
                            xValueMapper: (TaskPieChartData data, _) =>
                                data.status.getLocalizationText(context),
                            yValueMapper: (TaskPieChartData data, _) =>
                                data.taskCount,
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true),
                            pointColorMapper: (TaskPieChartData data, _) =>
                                data.status.color,
                          ),
                        ],
                        tooltipBehavior: _tooltip,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: Image.asset(AppAssets.gifCongrats).image,
                          ),
                        ),
                      ),
                    ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      textDescription,
                      style: context.textTheme.bodyMedium,
                    ),
                    SpacerComponent.l(),
                    SizedBox(
                      width: 120,
                      child: TMElevatedButton(
                        onPressed: () {},
                        label: context.l10n.seeall,
                        textColor: context.appColors.textWhite,
                        color: Colors.blue.shade300,
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: context.appColors.textWhite,
                          size: 16,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
