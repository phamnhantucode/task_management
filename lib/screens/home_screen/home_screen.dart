import 'package:flutter/material.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/component/top_header/primary.dart';

import '../component/task_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          TopHeader(
              title: context.l10n.header_home,
              leftAction: () => {print("Left clcik")},
              rightAction: () => {print("Right clcik")}),
          const SizedBox(height: 40),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: Colors.grey[300],
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
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    const Text(
                      "15 task",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 200,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Progress',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                  Text(
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
                                backgroundColor: Colors.white54,
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
                border: Border(
                    bottom: BorderSide(
                        width: 1, color: context.appColors.borderColor))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.today_task,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text("See all",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                _taskWidget(),
                _taskWidget(),
                _taskWidget(),
                _taskWidget(),
                _taskWidget(),
                _taskWidget(),
                _taskWidget(),
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
