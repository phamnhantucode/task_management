import 'package:flutter/material.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/screens/bottom_navigation/nav_bar.dart';
import 'package:room_master_app/screens/component/top_header/primary.dart';
import 'package:room_master_app/l10n/l10n.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
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
                        style: const TextStyle(fontSize: 20, color: Colors.white),
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
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                   Text("See all",
                      style: context.textTheme.bodyMedium),
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
      ),
      bottomNavigationBar: NavBar(
        pageIndex: 0,
        onTap: (e) => {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => {},
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            side: BorderSide(width: 3, color: context.appColors.buttonEnable)),
        child: Icon(
          Icons.add,
          color: context.appColors.buttonEnable,
          size: 32,
        ),
      ),
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
            offset: const Offset(0, -3), // Moves shadow to the top
          ),
          // Bottom shadow
          BoxShadow(
            color: context.appColors.borderColor,
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), // Moves shadow to the bottom
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
          IconButton(onPressed: () => {}, icon: const Icon(Icons.arrow_forward_ios))
        ],
      ),
    );
  }
}
