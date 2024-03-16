import 'package:flutter/material.dart';

class TopHeader extends StatefulWidget {
  const TopHeader({super.key, required this.title, required this.leftAction, required this.rightAction});
  final String title;
  final Function leftAction;
  final Function rightAction;
  @override
  State<StatefulWidget> createState() => TopHeaderState();
}

class TopHeaderState extends State<TopHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[300]),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_outlined,
                      size: 32,
                    ),
                  ),
                ),
                const Expanded(
                    child: Text(
                  'Home screen',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                )),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[300]),
                  child: const Center(
                    child: Icon(
                      Icons.notifications_none_outlined,
                      size: 32,
                    ),
                  ),
                ),
              ],
            );
  }
}