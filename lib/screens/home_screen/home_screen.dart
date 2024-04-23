import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/navigation/navigation.dart';
import 'package:room_master_app/screens/component/task_container.dart';
import 'package:room_master_app/screens/component/task_widget.dart';
import 'package:room_master_app/screens/component/top_header/primary.dart';
import 'package:room_master_app/l10n/l10n.dart';
import '../../blocs/authentication/authentication_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TopHeader(
                title: context.l10n.header_home,
                leftAction: () {
                  context.read<AuthenticationCubit>().logout();
                  context.go(NavigationPath.login);
                },
                rightAction: () => {print("Right clcik")}),
            const SizedBox(height: 40),
            Container(
              height: 200,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  backgroundColor:
                                      context.appColors.bgGrayLight,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ]),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(bottom: 10),
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
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(context.l10n.seeall, style: context.textTheme.bodyMedium),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(
                          width: 1, color: context.appColors.borderColor)),
                  boxShadow: [
                    BoxShadow(
                      color: context.appColors.borderColor,
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Moves shadow to the top
                    ),
                  ]),
            ),
            const Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  TaskWidget(
                      taskName: 'taskName',
                      imageUrl:
                          'https://cdn-icons-png.flaticon.com/128/11389/11389139.png',
                      time: '13: 30'),
                  TaskWidget(
                      taskName: 'taskName1',
                      imageUrl:
                          'https://cdn-icons-png.flaticon.com/128/11389/11389139.png',
                      time: '13: 30'),
                  TaskWidget(
                      taskName: 'taskName2',
                      imageUrl:
                          'https://cdn-icons-png.flaticon.com/128/11389/11389139.png',
                      time: '13: 30'),
                  TaskWidget(
                      taskName: 'taskName3',
                      imageUrl:
                          'https://cdn-icons-png.flaticon.com/128/11389/11389139.png',
                      time: '13: 30'),
                  TaskWidget(
                      taskName: 'taskName3',
                      imageUrl:
                          'https://cdn-icons-png.flaticon.com/128/11389/11389139.png',
                      time: '13: 30'),
                  TaskWidget(
                      taskName: 'taskName3',
                      imageUrl:
                          'https://cdn-icons-png.flaticon.com/128/11389/11389139.png',
                      time: '13: 30'),
                  const SizedBox(
                    height: 40,
                  )
                ],
              ),
            ))
          ],
        ),
    );
  }

  _taskWidget() {
    return TaskContainer(
      context: context,
      title: 'Test Title',
      content: 'Test content',
      backgroundColor: Colors.blue.shade50,
      iconBackgroundColor: Colors.blue.shade100,
      contentColor: Colors.blue.shade500,
      suffix: IconButton(
          onPressed: () => {}, icon: const Icon(Icons.arrow_forward_ios)),
    );
  }
}
