import 'package:avatar_stack/positions.dart';
import 'package:flutter/material.dart';
import 'package:avatar_stack/avatar_stack.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/navigation/navigation.dart';
import 'package:room_master_app/screens/component/task_container.dart';
import 'package:room_master_app/screens/component/top_header/primary.dart';
import 'package:room_master_app/l10n/l10n.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({super.key});

  @override
  State<StatefulWidget> createState() => ProjectDetailScreenState();
}

class ProjectDetailScreenState extends State<ProjectDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          TopHeader(
              title: 'Project detail',
              leftAction: () {
                context.go(NavigationPath.home);
              }),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name of Project',
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.grey[200], shape: BoxShape.circle),
                          child: Center(
                            child: Icon(
                              Icons.calendar_month,
                              size: 32,
                              color: context.appColors.buttonEnable,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          '04 April, at 11:30',
                          style: context.textTheme.labelMedium,
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              context.l10n.progress,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Expanded(
                                child: Text(
                              '40%',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ))
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: 0.4,
                                minHeight: 10,
                                backgroundColor: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      context.l10n.overview,
                      style: context.textTheme.titleLarge,
                    ),
                    const SafeArea(
                        child: Text(
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black54),
                    )),
                    const SizedBox(height: 20),
                    Text(
                      context.l10n.members,
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    buildMembers(),
                    const SizedBox(height: 20),
                    Text(
                      'Tasks',
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 440,
                      child: ListView.builder(
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
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          )
        ],
      )),
      floatingActionButton: MyFloatingActionButton(),
    );
  }

  buildMembers() {
    final settings = RestrictedAmountPositions(
      maxAmountItems: 5,
      maxCoverage: 0.3,
      minCoverage: 0.2,
    );
    return AvatarStack(
      settings: settings,
      height: 50,
      avatars: [for (var n = 0; n < 11; n++) NetworkImage(getAvatarUrl(n))],
    );
  }

  _taskWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 24, left: 4, right: 4),
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: context.appColors.borderColor,
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -5), // Moves shadow to the top
          ),
          // Bottom shadow
          BoxShadow(
            color: context.appColors.borderColor,
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 5), // Moves shadow to the bottom
          ),
        ],
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.network(
                "https://cdn-icons-png.flaticon.com/128/11389/11389139.png",
                width: 80,
                height: 80,
              ),
              const SizedBox(
                width: 20,
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'UI Meeting',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text('13:10 - 14:30'),
                ],
              )
            ],
          ),
          IconButton(onPressed: () => {}, icon: Icon(Icons.arrow_forward_ios))
        ],
      ),
    );
  }
}

String getAvatarUrl(int n) {
  final url = 'https://robohash.org/$n?bgset=bg1';
  return url;
}

class MyFloatingActionButton extends StatefulWidget {
  @override
  _MyFloatingActionButtonState createState() => _MyFloatingActionButtonState();
}

class _MyFloatingActionButtonState extends State<MyFloatingActionButton> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isExpanded)
          FloatingActionButton(
            backgroundColor: context.appColors.buttonEnable,
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                side: BorderSide(
                    width: 3, color: context.appColors.buttonEnable)),
            mini: true,
            onPressed: () {
              // Add your action for this button
              // Add bottom sheet
            },
            child: const Icon(Icons.edit),
          ),
        if (_isExpanded)
          FloatingActionButton(
            backgroundColor: context.appColors.buttonEnable,
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                side: BorderSide(
                    width: 3, color: context.appColors.buttonEnable)),
            mini: true,
            onPressed: () {
              // Add your action for this button
              context.go(NavigationPath.newTask);
            },
            child: const Icon(Icons.add),
          ),
        if (_isExpanded)
          const SizedBox(
            height: 16,
          ),
        FloatingActionButton(
          backgroundColor: context.appColors.buttonEnable,
          shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              side:
                  BorderSide(width: 3, color: context.appColors.buttonEnable)),
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Icon(_isExpanded ? Icons.close : Icons.add),
        ),
      ],
    );
  }
}
